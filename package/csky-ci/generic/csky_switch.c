#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

#define FALSE  -1
#define TRUE   0

int speed_arr[] = {B115200, B38400, B19200, B9600, B4800, B2400, B1200, B300,
                   B115200, B38400, B19200, B9600, B4800, B2400, B1200, B300,
                  };
int name_arr[] = {115200, 38400, 19200, 9600, 4800, 2400, 1200,  300,
                  115200, 38400, 19200, 9600, 4800, 2400, 1200,  300,
                 };

void set_speed(int fd, int speed)
{
	int i;
	int status;
	struct termios Opt;

	tcgetattr(fd, &Opt);
	for (i = 0;  i < sizeof(speed_arr) / sizeof(int);  i++) {
		if (speed == name_arr[i]) {
			tcflush(fd, TCIOFLUSH);
			cfsetispeed(&Opt, speed_arr[i]);
			cfsetospeed(&Opt, speed_arr[i]);
			status = tcsetattr(fd, TCSANOW, &Opt);
			if (status != 0) {
				perror("tcsetattr fd1");
				return;
			}
			tcflush(fd, TCIOFLUSH);
		}
	}
}

int set_Parity(int fd, int databits, int stopbits, int parity)
{
	struct termios options;

	if (tcgetattr(fd, &options)  !=  0) {
		perror("SetupSerial 1");
		return (FALSE);
	}

	options.c_cflag &= ~CSIZE;

	switch (databits) {
	case 7:
		options.c_cflag |= CS7;
		break;
	case 8:
		options.c_cflag |= CS8;
		break;
	default:
		fprintf(stderr, "Unsupported data size\n");
		return (FALSE);
	}

	switch (parity) {
	case 'n':
	case 'N':
		options.c_cflag &= ~PARENB;
		options.c_iflag &= ~INPCK;
		break;
	case 'o':
	case 'O':
		options.c_cflag |= (PARODD | PARENB);
		options.c_iflag |= INPCK;
		break;
	case 'e':
	case 'E':
		options.c_cflag |= PARENB;
		options.c_cflag &= ~PARODD;
		options.c_iflag |= INPCK;
		break;
	case 'S':
	case 's':
		options.c_cflag &= ~PARENB;
		options.c_cflag &= ~CSTOPB;
		break;
	default:
		fprintf(stderr, "Unsupported parity\n");
		return (FALSE);
	}

	switch (stopbits) {
	case 1:
		options.c_cflag &= ~CSTOPB;
		break;
	case 2:
		options.c_cflag |= CSTOPB;
		break;
	default:
		fprintf(stderr, "Unsupported stop bits\n");
		return (FALSE);
	}

	if (parity != 'n')
		options.c_iflag |= INPCK;

	tcflush(fd, TCIFLUSH);
	options.c_cc[VTIME] = 3;
	options.c_cc[VMIN] = 0;

	if (tcsetattr(fd, TCSANOW, &options) != 0) {
		perror("SetupSerial 3");
		return (FALSE);
	}

	options.c_lflag  &= ~(ICANON | ECHO | ECHOE | ISIG);
	options.c_oflag  &= ~OPOST;

	return (TRUE);
}

int main(int argc, char *argv[])
{

	int fd, res;
	char off[4] = {0xa0, 0x01, 0x00, 0xa1};
	char on[4] = {0xa0, 0x01, 0x01, 0xa2};

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror(argv[1]);
		exit(1);
	}

	set_speed(fd, 9600);
	if (set_Parity(fd, 8, 1, 'N') == FALSE)  {
		printf("Set Parity Error\n");
		exit(0);
	}

	if (!strcmp(argv[2], "on")) {
		res = write(fd, on, 4);
		printf("switch on... ret %d\n", res);
	} else {
		res = write(fd, off, 4);
		printf("switch off... ret %d\n", res);
	}

	close(fd);

	return 0;
}
