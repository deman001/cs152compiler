lexer:
	flex mini_l.lex
	gcc lex.yy.c -lfl -o lexer

clean:
	rm -rf lex.yy.c lexer
