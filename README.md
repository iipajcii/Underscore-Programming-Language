# Underscore Programming Language

The Underscore Programming Language is a simple, general purpose, interpreted, imperative programming language created in C with the help of the Lex lexer and Yacc tokenizer.

## How to Build

This project uses the **Make** tool to help automate compiliing the interpreter. To build the project simply using the command:
```
make
```
_or_
``` 

make main
```

After you have built the `main` interpreter file you can use the command:
```
make test
```
to feed the programs as input into the program.


If you would prefer you can also set one file as an argument instead. This sets the stdin of the program as the file.
```
./main < input1.txt
```
is equivalent to:
```
./main input1.txt
```

Have fun with underscore!
