
#include "uart.h"

#include <stdio.h>
#include <termios.h>
#include <unistd.h>

int uart_putc(char c) {
	int ch = fputc(c, stdout);
	fflush(stdout);
	return ch;
}

int uart_getc(void) {

	struct termios oldt, newt;
	int ch;
	tcgetattr( STDIN_FILENO, &oldt);
	newt = oldt;
	cfmakeraw(&newt);
	tcsetattr( STDIN_FILENO, TCSANOW, &newt);
	ch = fgetc(stdin);
	tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
	return ch;
}

int uart_puts(const char *s) {
	return fputs(s, stdout);
}

void uart_init(void) {

}
