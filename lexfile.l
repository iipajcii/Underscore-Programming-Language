%{
#include "y.tab.h"
#include "symbol_table.h"
#include <math.h>
%}

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
		yylval.dval = atof(yytext);
		return NUMBER;
	}

[ \t]	;		 /* ignore white space */

PRINT	{ return PRINT; }
(\"(\\.|[^"\\])*\") { yylval.sval = strdup(yytext); return STRING; }

, {return PRINT_COMMA;}

[A-Za-z][A-Za-z0-9]*	{	/* return symbol pointer */
		yylval.symp = symlook(yytext);
		return NAME;
	}


\n	|
.	return yytext[0];

%%
int yywrap(void) { 
  return 1;
}

int yyerror(char *error_value) { 
  fprintf(stderr,"error: '%s'\n", error_value); 
  return 0;
}