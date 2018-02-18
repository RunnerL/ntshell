#include "uart.h"

#include "ntshell.h"
#include "ntlibc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PROMPOT	"bootloader>"

#define UNUSED_VARIABLE(N)  do { (void)(N); } while (0)

static int func_read(char *buf, int cnt, void *extobj) {
	int i;
	UNUSED_VARIABLE(extobj);
	for (i = 0; i < cnt; i++) {
		buf[i] = uart_getc();
	}
	return cnt;
}

static int func_write(const char *buf, int cnt, void *extobj) {
	int i;
	UNUSED_VARIABLE(extobj);
	for (i = 0; i < cnt; i++) {
		uart_putc(buf[i]);
	}
	return cnt;
}

static int func_callback(const char *text, void *extobj) {
	ntshell_t *ntshell = (ntshell_t *) extobj;
	UNUSED_VARIABLE(ntshell);
	UNUSED_VARIABLE(extobj);
	if (ntlibc_strlen(text) > 0) {
		if (!strcmp(text, "quit")) {
			uart_puts("bye\r\n");
			exit(EXIT_SUCCESS);
		} else if (!strcmp(text, "quick")) {
			uart_puts("OK\r\n");
		} else {
			uart_puts("command '");
			uart_puts(text);
			uart_puts("' not found\r\n");
		}

	}
	return 0;
}

int main(void) {
	ntshell_t ntshell;
	uart_init();
	ntshell_init(&ntshell, func_read, func_write, func_callback,
			(void *) &ntshell);
	ntshell_set_prompt(&ntshell, PROMPOT);
	ntshell_execute(&ntshell);
	return 0;
}

