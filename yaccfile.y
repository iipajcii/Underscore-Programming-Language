%{
#include "symbol_table.h"
#include <string.h>
int yylex();
int yyerror(char *);

int line_num = 0;
%}

%union {
	double dval;
	char* sval;
	struct symtab *symp;
}
%token NEWLINE COMMENT
%token <symp> NAME
%token <dval> NUMBER
%token PRINT
%token <sval> STRING
%left '-' '+'
%left '*' '/'
%right COMMA
%nonassoc UMINUS

%type <dval> expression
%%

statement_list:	statement NEWLINE { line_num++; }
	|	statement_list statement NEWLINE
	;

statement:	NAME '=' expression	{ $1->value = $3; }
	|  PRINT print_expressions { printf("\n"); }
	|	expression		{ printf("%g\n", $1); }
	|  NAME '=' STRING { $1->string_value = $3; }
	|  STRING { 
			int len = strlen($1);
			char buffer[500] = "";
			for(int i = 1; i < len - 1; i++){
				char temp_string[2] = {$1[i],'\0'};
				strcat(buffer,temp_string);
			}
			printf("%s\n", buffer); 
		}
	| COMMENT NEWLINE {}
	| NEWLINE {}
	;

print_expressions: print_expression
	| print_expression print_expressions

print_expression: STRING {
		int len = strlen($1);
		char buffer[500] = "";
		for(int i = 1; i < len - 1; i++){
			char temp_string[2] = {$1[i],'\0'};
			strcat(buffer,temp_string);
		}
		printf("%s", buffer); 
	}
	| NUMBER { printf("%g", $1); }
	| COMMA {}
	| NAME { 
		if($1->string_value){
			int len = strlen($1->string_value);
			char buffer[500] = "";
			for(int i = 1; i < len - 1; i++){
				char temp_string[2] = {$1->string_value[i],'\0'};
				strcat(buffer,temp_string);
			}
			printf("%s", buffer); 
		}
		else if ($1->value){
			double __ = $1->value; 
			printf("%f",__);
		} 
	}

expression:	expression '+' expression { $$ = $1 + $3; }
	|	expression '-' expression { $$ = $1 - $3; }
	|	expression '*' expression { $$ = $1 * $3; }
	|	expression '/' expression
				{	if($3 == 0.0)
						yyerror("divide by zero");
					else
						$$ = $1 / $3;
				}
	|	'-' expression %prec UMINUS	{ $$ = -$2; }
	|	'(' expression ')'	{ $$ = $2; }
	|	NUMBER
	|  NAME { 
			if($1->string_value){
				int len = strlen($1->string_value);
				char buffer[500] = "";
				for(int i = 1; i < len - 1; i++){
					char temp_string[2] = {$1->string_value[i],'\0'};
					strcat(buffer,temp_string);
				}
			}
			else if ($1->value){
				double __ = $1->value; 
				$$ = $1->value;
			} 
		}
	;
%%
/* look up a symbol table entry, add if not present */
struct symtab *
symlook(s)
char *s;
{
	char *p;
	struct symtab *sp;
	
	for(sp = symtab; sp < &symtab[NSYMS]; sp++) {
		/* is it already here? */
		if(sp->name && !strcmp(sp->name, s))
			return sp;
		
		/* is it free */
		if(!sp->name) {
			sp->name = strdup(s);
			return sp;
		}
		/* otherwise continue to next */
	}
	yyerror("Too many symbols");
	exit(1);	/* cannot continue */
} /* symlook */

/* Auxiliary functions */
int main() { 
   while(1) {
   	yyparse();
   }
}
