lexer:
	flex 862057097-862037341.lex
	gcc lex.yy.c -lfl -o lexer

clean:
	rm -rf lex.yy.c lexer
