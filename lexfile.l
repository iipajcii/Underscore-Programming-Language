%{
#include "y.tab.h"
#include "symbol_table.h"
#include <math.h>
#include <stdio.h>
%}

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
		yylval.dval = atof(yytext);
		return NUMBER;
	}

[ \t]	;		 /* ignore white space */

PRINT	{ return PRINT; }
(\"(\\.|[^"\\])*\") { yylval.sval = strdup(yytext); return STRING; }

, {return COMMA;}

[A-Za-z][A-Za-z0-9]*	{	/* return symbol pointer */
		yylval.symp = symlook(yytext);
		return NAME;
	}


[/]{2}.* {printf("comment"); return COMMENT;}
. { return yytext[0]; }

\n {return NEWLINE;}

%%
int yywrap(void) { 
  return 1;
}

int yyerror(char *error_value) { 
  fprintf(stderr,"error: '%s'\n", error_value); 
  return 0;
}