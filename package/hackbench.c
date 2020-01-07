/*
 * This is the latest version of hackbench.c, that tests scheduler and
 * unix-socket (or pipe) performance.
 *
 * Usage: hackbench [-pipe] <num groups> [process|thread] [loops]
 *
 * Build it with:
 *   gcc -g -Wall -O2 -o hackbench hackbench.c -lpthread
 *
 * Downloaded from http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
 * February 19 2010.
 *
 */

/* Test groups of 20 processes spraying to 20 receivers */
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/poll.h>
#include <limits.h>
#include <getopt.h>
#include <signal.h>

static unsigned int datasize = 100;
static unsigned int loops = 100;
static unsigned int num_groups = 10;
static unsigned int num_fds = 20;

/*
 * 0 means thread mode and others mean process (default)
 */
static unsigned int process_mode = 1;

static int use_pipes = 0;

struct sender_context {
	unsigned int num_fds;
	int ready_out;
	int wakefd;
	int out_fds[0];
};

struct receiver_context {
	unsigned int num_packets;
	int in_fds[2];
	int ready_out;
	int wakefd;
};


typedef union {
	pthread_t threadid;
	pid_t	  pid;
	long long error;
} childinfo_t;

childinfo_t *child_tab = NULL;
unsigned int total_children = 0;
unsigned int signal_caught = 0;

inline static void sneeze(const char *msg) {
	/* Avoid calling these functions when called from a code path
	 * which involves sigcatcher(), as they are not reentrant safe.
	 */
	if( !signal_caught ) {
		fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
	}
}

static void barf(const char *msg)
{
	sneeze(msg);
	exit(1);
}

static void print_usage_exit()
{
	printf("Usage: hackbench [-p|--pipe] [-s|--datasize <bytes>] [-l|--loops <num loops>]\n"
	       "\t\t [-g|--groups <num groups] [-f|--fds <num fds>]\n"
	       "\t\t [-T|--threads] [-P|--process] [--help]\n");
	exit(1);
}

static void fdpair(int fds[2])
{
	if (use_pipes) {
		if (pipe(fds) == 0)
			return;
	} else {
		if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == 0)
			return;
	}
	barf("Creating fdpair");
}

/* Block until we're ready to go */
static void ready(int ready_out, int wakefd)
{
	char dummy = '*';
	struct pollfd pollfd = { .fd = wakefd, .events = POLLIN };

	/* Tell them we're ready. */
	if (write(ready_out, &dummy, 1) != 1)
		barf("CLIENT: ready write");

	/* Wait for "GO" signal */
	if (poll(&pollfd, 1, -1) != 1)
		barf("poll");
}

/* Sender sprays loops messages down each file descriptor */
static void *sender(struct sender_context *ctx)
{
	char data[datasize];
	unsigned int i, j;

	ready(ctx->ready_out, ctx->wakefd);
	memset(&data, '-', datasize);

	/* Now pump to every receiver. */
	for (i = 0; i < loops; i++) {
		for (j = 0; j < ctx->num_fds; j++) {
			int ret, done = 0;

again:
			ret = write(ctx->out_fds[j], data + done, sizeof(data)-done);
			if (ret < 0)
				barf("SENDER: write");
			done += ret;
			if (done < sizeof(data))
				goto again;
		}
	}

	return NULL;
}


/* One receiver per fd */
static void *receiver(struct receiver_context* ctx)
{
	unsigned int i;

	if (process_mode)
		close(ctx->in_fds[1]);

	/* Wait for start... */
	ready(ctx->ready_out, ctx->wakefd);

	/* Receive them all */
	for (i = 0; i < ctx->num_packets; i++) {
		char data[datasize];
		int ret, done = 0;

again:
		ret = read(ctx->in_fds[0], data + done, datasize - done);
		if (ret < 0)
			barf("SERVER: read");
		done += ret;
		if (done < datasize)
			goto again;
	}
	if (ctx) {
		free(ctx);
	}
	return NULL;
}

childinfo_t create_worker(void *ctx, void *(*func)(void *))
{
	pthread_attr_t attr;
	int err;
	childinfo_t child;
	pid_t childpid;

	switch (process_mode) {
	case 1: /* process mode */
		/* Fork the sender/receiver child. */
		switch ((childpid = fork())) {
			case -1:
				sneeze("fork()");
				child.error = -1;
				return child;
			case 0:
				(*func) (ctx);
				exit(0);
		}
		child.pid = childpid;
		break;

	case 0: /* threaded mode */
		if (pthread_attr_init(&attr) != 0) {
			sneeze("pthread_attr_init()");
			child.error = -1;
			return child;
		}

#ifndef __ia64__
		if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0) {
			sneeze("pthread_attr_setstacksize()");
			child.error = -1;
			return child;
		}
#endif

		if ((err=pthread_create(&child.threadid, &attr, func, ctx)) != 0) {
			sneeze("pthread_create failed()");
			child.error = -1;
			return child;
		}
		break;
	}
	return child;
}

unsigned int reap_workers(childinfo_t *child, unsigned int totchld, unsigned int dokill)
{
	unsigned int i, rc = 0;
	int status, err;
	void *thr_status;

	for( i = 0; i < totchld; i++ ) {
		switch( process_mode ) {
		case 1: /* process mode */
			if( dokill ) {
				kill(child[i].pid, SIGTERM);
			}
			fflush(stdout);
			waitpid(child[i].pid, &status, 0);
			if (!WIFEXITED(status))
				rc++;
			break;
		case 0: /* threaded mode */
			if( dokill ) {
				pthread_kill(child[i].threadid, SIGTERM);
			}
			err = pthread_join(child[i].threadid, &thr_status);
			if( err != 0 ) {
				sneeze("pthread_join()");
				rc++;
			}
			break;
		}
	}
	return rc;
}

/* One group of senders and receivers */
static unsigned int group(childinfo_t *child,
			  unsigned int tab_offset,
			  unsigned int num_fds,
			  int ready_out,
			  int wakefd)
{
	unsigned int i;
	struct sender_context* snd_ctx = malloc (sizeof(struct sender_context)
			+num_fds*sizeof(int));

	if (!snd_ctx) {
		sneeze("malloc() [sender ctx]");
		return 0;
	}


	for (i = 0; i < num_fds; i++) {
		int fds[2];
		struct receiver_context* ctx = malloc (sizeof(*ctx));

		if (!ctx) {
			sneeze("malloc() [receiver ctx]");
			return (i > 0 ? i-1 : 0);
		}


		/* Create the pipe between client and server */
		fdpair(fds);

		ctx->num_packets = num_fds*loops;
		ctx->in_fds[0] = fds[0];
		ctx->in_fds[1] = fds[1];
		ctx->ready_out = ready_out;
		ctx->wakefd = wakefd;

		child[tab_offset+i] = create_worker(ctx, (void *)(void *)receiver);
		if( child[tab_offset+i].error < 0 ) {
			return (i > 0 ? i-1 : 0);
		}
		snd_ctx->out_fds[i] = fds[1];
		if (process_mode)
			close(fds[0]);
	}

	/* Now we have all the fds, fork the senders */
	for (i = 0; i < num_fds; i++) {
		snd_ctx->ready_out = ready_out;
		snd_ctx->wakefd = wakefd;
		snd_ctx->num_fds = num_fds;

		child[tab_offset+num_fds+i] = create_worker(snd_ctx, (void *)(void *)sender);
		if( child[tab_offset+num_fds+i].error < 0 ) {
			return (num_fds+i)-1;
		}
	}

	/* Close the fds we have left */
	if (process_mode)
		for (i = 0; i < num_fds; i++)
			close(snd_ctx->out_fds[i]);

	/* Return number of children to reap */
	return num_fds * 2;
}

static void process_options (int argc, char *argv[])
{
	int error = 0;

	while( 1 ) {
		int optind = 0;

		static struct option longopts[] = {
			{"pipe",      no_argument,	 NULL, 'p'},
			{"datasize",  required_argument, NULL, 's'},
			{"loops",     required_argument, NULL, 'l'},
			{"groups",    required_argument, NULL, 'g'},
			{"fds",	      required_argument, NULL, 'f'},
			{"threads",   no_argument,	 NULL, 'T'},
			{"processes", no_argument,	 NULL, 'P'},
			{"help",      no_argument,	 NULL, 'h'},
			{NULL, 0, NULL, 0}
		};

		int c = getopt_long(argc, argv, "ps:l:g:f:TPh",
				    longopts, &optind);
		if (c == -1) {
			break;
		}
		switch (c) {
		case 'p':
			use_pipes = 1;
			break;

		case 's':
			if (!(argv[optind] && (datasize = atoi(optarg)) > 0)) {
				fprintf(stderr, "%s: --datasize|-s requires an integer > 0\n", argv[0]);
				error = 1;
			}
			break;

		case 'l':
			if (!(argv[optind] && (loops = atoi(optarg)) > 0)) {
				fprintf(stderr, "%s: --loops|-l requires an integer > 0\n", argv[0]);
				error = 1;
			}
			break;

		case 'g':
			if (!(argv[optind] && (num_groups = atoi(optarg)) > 0)) {
				fprintf(stderr, "%s: --groups|-g requires an integer > 0\n", argv[0]);
				error = 1;
			}
			break;

		case 'f':
			if (!(argv[optind] && (num_fds = atoi(optarg)) > 0)) {
				fprintf(stderr, "%s: --fds|-f requires an integer > 0\n", argv[0]);
				error = 1;
			}
			break;

		case 'T':
			process_mode = 0;
			break;
		case 'P':
			process_mode = 1;
			break;

		case 'h':
			print_usage_exit();

		default:
			error = 1;
		}
	}

	if( error ) {
		exit(1);
	}
}

void sigcatcher(int sig) {
	/* All caught signals will cause the program to exit */
	signal_caught = 1;
	if( child_tab && (total_children > 0) ) {
		reap_workers(child_tab, total_children, 1);
	}
	fprintf(stderr, "** Operation aborted **\n");
	exit(0);
}

int main(int argc, char *argv[])
{
	unsigned int i;
	struct timeval start, stop, diff;
	int readyfds[2], wakefds[2];
	char dummy;

	process_options (argc, argv);

	printf("Running in %s mode with %d groups using %d file descriptors each (== %d tasks)\n",
	       (process_mode == 0 ? "threaded" : "process"),
	       num_groups, 2*num_fds, num_groups*(num_fds*2));
	printf("Each sender will pass %d messages of %d bytes\n", loops, datasize);
	fflush(NULL);

	child_tab = calloc(num_fds * 2 * num_groups, sizeof(childinfo_t));
	if (!child_tab)
		barf("main:malloc()");

	fdpair(readyfds);
	fdpair(wakefds);

	/* Catch some signals */
	signal(SIGINT, sigcatcher);
	signal(SIGTERM, sigcatcher);
	signal(SIGHUP, SIG_IGN);

	total_children = 0;
	for (i = 0; i < num_groups; i++) {
		int c = group(child_tab, total_children, num_fds, readyfds[1], wakefds[0]);
		if( c != (num_fds*2) ) {
			fprintf(stderr, "%i children started.  Expected %i\n", c, num_fds*2);
			reap_workers(child_tab, total_children + c, 1);
			barf("Creating workers");
		}
		total_children += c;
	}

	/* Wait for everyone to be ready */
	for (i = 0; i < total_children; i++)
		if (read(readyfds[0], &dummy, 1) != 1) {
			reap_workers(child_tab, total_children, 1);
			barf("Reading for readyfds");
		}

	gettimeofday(&start, NULL);

	/* Kick them off */
	if (write(wakefds[1], &dummy, 1) != 1) {
		reap_workers(child_tab, total_children, 1);
		barf("Writing to start senders");
	}

	/* Reap them all */
	reap_workers(child_tab, total_children, 0);

	gettimeofday(&stop, NULL);

	/* Print time... */
	timersub(&stop, &start, &diff);
	printf("Time: %lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
	free(child_tab);
	exit(0);
}
