main: lexfile.l yaccfile.y symbol_table.h
	lex lexfile.l
	yacc -d yaccfile.y
	gcc lex.yy.c y.tab.c -o main
