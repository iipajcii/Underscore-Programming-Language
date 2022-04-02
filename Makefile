main: lexfile.l yaccfile.y symbol_table.h
	lex lexfile.l
	yacc -d yaccfile.y
	gcc lex.yy.c y.tab.c -o main

test: main
	./main < input1.txt
	./main < input2.txt
