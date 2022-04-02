%{
#include "symbol_table.h"
#include <string.h>
#include <unistd.h>

int yylex();
int yyerror(char *);

int line_num = 0;
int stop = 0;
%}

%union {
	double dval;
	char* sval;
	struct symtab *symp;
}
%token NEWLINE COMMENT UNDERSCORE
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

statement_list:	statement { line_num++; }
	|	statement NEWLINE statement_list {}
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
	| UNDERSCORE { stop = 1; }
	| COMMENT {  }
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
	| NUMBER { printf("%.2f", $1); }
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
			printf("%.2f",__);
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
int main(int argc, char *argv[]) {
	if(argv[1]){freopen(argv[1],"r",stdin);}
	else {puts("*** ENTERING REPL ***");}
   while(!stop) {
   	yyparse();
   }
   if(argv[1]){puts("\n*** YOUR CODE WAS INTERPRETED SUCCESSFULLY! ***\n");}
   else {puts("*** EXITING REPL ***");}
}
