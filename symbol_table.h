/*
 *	Header for calculator program
 */
#include <stdlib.h>
#include <stdio.h>
#define NSYMS 200	/* maximum number of symbols */

struct symtab {
	char *name;
	double value;
	char *string_value;
	int line_num;
} symtab[NSYMS];

struct symtab* symlook();
