#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <string.h>

void setTermios(struct termios * pNewtio, int uBaudRate)
{
	bzero(pNewtio, sizeof(struct termios));

	pNewtio->c_cflag = uBaudRate | CS8 | CREAD | CLOCAL;
	pNewtio->c_iflag = IGNPAR;
	pNewtio->c_oflag = 0;
	pNewtio->c_lflag = 0;
	/*
	 initialize all control characters
	 default values can be found in /usr/include/termios.h, and
	 are given in the comments, but we don't need them here
	 */
	pNewtio->c_cc[VINTR] = 0; /* Ctrl-c */
	pNewtio->c_cc[VQUIT] = 0; /* Ctrl-\ */
	pNewtio->c_cc[VERASE] = 0; /* del */
	pNewtio->c_cc[VKILL] = 0; /* @ */
	pNewtio->c_cc[VEOF] = 4; /* Ctrl-d */
	pNewtio->c_cc[VTIME] = 5; /* inter-character timer, timeout VTIME*0.1 */
	pNewtio->c_cc[VMIN] = 0; /* blocking read until VMIN character arrives */
	pNewtio->c_cc[VSWTC] = 0; /* '\0' */
	pNewtio->c_cc[VSTART] = 0; /* Ctrl-q */
	pNewtio->c_cc[VSTOP] = 0; /* Ctrl-s */
	pNewtio->c_cc[VSUSP] = 0; /* Ctrl-z */
	pNewtio->c_cc[VEOL] = 0; /* '\0' */
	pNewtio->c_cc[VREPRINT] = 0; /* Ctrl-r */
	pNewtio->c_cc[VDISCARD] = 0; /* Ctrl-u */
	pNewtio->c_cc[VWERASE] = 0; /* Ctrl-w */
	pNewtio->c_cc[VLNEXT] = 0; /* Ctrl-v */
	pNewtio->c_cc[VEOL2] = 0; /* '\0' */
}

#define BUFSIZE 512
int main(int argc, char **argv)
{
	int fd;
	int nread;
	char buff[BUFSIZE];
	struct termios oldtio, newtio;
	struct timeval tv;
	fd_set rfds;

{
	char *dev = "/dev/csky_serial";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}

{
	char *dev = "/dev/ttyUSB0";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}

{
	char *dev = "/dev/ttyUSB1";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}


{
	char *dev = "/dev/ttyUSB2";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}

{
	char *dev = "/dev/ttyUSB3";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}


{
	char *dev = "/dev/ttyUSB4";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}


{
	char *dev = "/dev/ttyUSB5";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}


{
	char *dev = "/dev/ttyUSB6";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}

{
	char *dev = "/dev/ttyUSB7";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}

{
	char *dev = "/dev/ttyUSB8";

	if ((fd = open(dev, O_RDWR | O_NOCTTY)) < 0) {
		printf("err: can't open serial port, %s!\n", dev);
	} else
		goto good;
}
	return -1;
good:
	tcgetattr(fd, &oldtio);
	setTermios(&newtio, B115200);
	tcflush(fd, TCIFLUSH);
	tcsetattr(fd, TCSANOW, &newtio);

	tv.tv_sec = 30;
	tv.tv_usec = 0;

	setvbuf(stdout, NULL, _IONBF, 0);

	while (1) {
		FD_ZERO(&rfds);
		FD_SET(fd, &rfds);
		if (select(1 + fd, &rfds, NULL, NULL, &tv) > 0) {
			if (FD_ISSET(fd, &rfds)) {
				nread = read(fd, buff, BUFSIZE);
				buff[nread] = '\0';
				printf("%s", buff);
			}
		}
	}
	tcsetattr(fd, TCSANOW, &oldtio);
	close(fd);
}
