/* CS152 Project Phase 2 			  */
/* Mini-l Bison Parser 				  */
/* Written by Johnny Vo and Dale Eman */

/* C Declarations */
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *msg);
int yylex(void);
extern int currLine;
extern int currpos;
extern char* yytext;
%}

/* Bison Declarations */
%union{
	char id[30];
	int val;
}

%error-verbose
%start prog_start

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE FOR WHILE DO BEGINLOOP ENDLOOP BREAK READ WRITE AND OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <val> NUMBER
%token <id> IDENTIFIER

%right ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD
%right UMINUS
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN

/* Grammer Rules */

%%
prog_start:			function_loop {printf("prog_start -> function_loop\n");}
				;
function_loop:			/*epsilon*/ {printf("function_loop -> epsilon\n");}
				| function_loop FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declaration_loop END_PARAMS BEGIN_LOCALS declaration_loop END_LOCALS BEGIN_BODY statement_loop END_BODY {printf("function_loop -> function_loop FUNCTION IDENTIFIER %s SEMICOLON BEGIN_PARAMS declaration_loop END_PARAMS BEGIN_LOCALS declaration_loop END_LOCALS BEGIN_BODY statement_loop END_BODY\n", $3);}
				;
declaration_loop: 		/*epsilon*/ {printf("declaration_loop -> epsilon\n");}
				| declaration_loop declaration SEMICOLON
				{printf("declaration_loop -> declaration_loop declaration SEMICOLON\n");}
				;
declaration:			identity_loop COLON array INTEGER {printf("declaration -> identitiy_loop COLON array INTEGER\n");}
				;
identity_loop:			IDENTIFIER {printf("identity_loop -> IDENTITY %s\n", $1);}
				| identity_loop COMMA IDENTIFIER {printf("identity_cycle -> identity_cycle COMMA IDENEITY %s\n", $3); }
				;
statement_loop:			statement SEMICOLON {printf("statement_loop -> statement SEMICOLON\n");}
				| statement_loop statement SEMICOLON {printf("statement_loop -> statement_loop statement SEMICOLON\n");}
				;
array:				/*epsilon*/ {printf("array -> epsilon\n");}
				| ARRAY L_SQUARE_BRACKET NUMBER  R_SQUARE_BRACKET OF {printf("array -> ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF\n", $3);}
				| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF {printf("array -> ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF\n", $3, $6);}
				;
statement:			assignment {printf("statement -> assignment loop\n");}
				| if {printf("statement -> if\n");}
				| while {printf("statement -> while\n");}
				| do {printf("statement -> do\n");}
				| for {printf("statement -> for\n");}
				| read {printf("statement -> read\n");}
				| write {printf("statement -> write\n");}
				| break {printf("statement -> break\n");}
				| return {printf("statement -> return\n");}
				;
assignment:			var ASSIGN expression {printf("assignment -> var ASSIGN exp\n");}
				;
if:				IF bool_expr THEN statement_loop else ENDIF {printf("if -> IF bool_expr THEN statement_loop else ENDIF\n");}
				;
else:				/*epsilon*/ {printf("else -> epsilon\n");}
				| ELSE statement_loop {printf("else -> ELSE statement_loop\n");}
				;
while:				WHILE bool_expr BEGINLOOP statement_loop ENDLOOP {printf("while -> WHILE bool_expr BEGINLOOP statement_loop ENDLOOP\n");}
				;
do:				DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr {printf("do -> DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr\n");}
				;
for:				FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP statement_loop ENDLOOP {printf("for -> FOR var ASSIGN NUMBER %d SEMICOLON bool_expr SEMICOLON var ASSIGN exp BEGINLOOP statement_loop ENDLOOP\n", $4);}
				;
read:				READ var_loop {printf("read -> READ var_loop\n");}
				;
write:				WRITE var_loop {printf("write -> WRITE var_loop\n");}
				;
break:				BREAK {printf("break -> BREAK\n");}
				;
return:				RETURN expression {printf("return -> RETURN exp\n");}
var_loop:			var {printf("var_loop -> var\n");}
				| var_loop COMMA var {printf("var_loop -> var_loop COMMA var\n");}
				;
bool_expr:			rel_and_expr {printf("bool_expr -> rel_and_expr\n");}
				| bool_expr OR rel_and_expr {printf("bool_expr-> rel_and_expr AND rel_expr\n");}
				;
rel_and_expr:			rel_expr {printf("rel_and_expr -> rel_expr\n");}
				| rel_and_expr AND rel_expr {printf("rel_and_expr -> rel_and_expr AND rel_expr\n");}
				;
rel_expr:			rel_expr_og {printf("rel_expr -> rel_exp_og\n");}
				| NOT rel_expr_og {printf("rel_expr -> NOT rel_expr_og\n");}
				;
rel_expr_og:			expression comp expression {printf("rel_exp_og -> expression comp expression\n");}
				| TRUE {printf("rel_exp_og -> TRUE\n");}
				| FALSE {printf("rel_exp_og -> FALSE\n");}
				| L_PAREN bool_expr R_PAREN {printf("rel_exp_og -> L_PAREN bool_expr R_PAREN\n");}
				;
comp:           		EQ {printf("comp -> EQ\n");}
               			| NEQ {printf("comp -> NEQ\n");}
				| LT {printf("comp -> LT\n");}
				| GT {printf("comp -> GT\n");}
				| LTE {printf("comp -> LTE\n");}
				| GTE {printf("comp -> GTE\n");}
				;
expression:			mult_expr {printf("expression -> mult_expr\n");}
				| expression ADD mult_expr
				| expression SUB mult_expr
				;
mult_expr:			term_loop
				| mult_expr MULT term_loop
				| mult_expr DIV term_loop
				| mult_expr MOD term_loop
				;
term_loop:			term {printf("term_loop -> term\n");}
				| SUB term %prec UMINUS {printf("term_loop -> SUB term \%prec UMINUS\n");}
				| IDENTIFIER L_PAREN param_loop R_PAREN {printf("term_loop -> IDENTIFIER %s L_PAREN param_cycle R_PAREN\n", $1);}
				;
term:				var {printf("term -> var\n");}
				| NUMBER {printf("term -> NUM %d\n", $1);}
				| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
				;
param_loop:			/*epsilon*/ {printf("param_loop -> epsilon\n");}
				| expr_loop {printf("param_loop -> expr_loop\n");}
				;
expr_loop:			expression {printf("expr_loop -> expr\n");}
				| expr_loop COMMA expression {printf("expr_loop -> expr_loop COMMA expression\n");}
				;
var:				IDENTIFIER {printf("var -> IDENTIFIER %s\n", $1);}
				| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> IDENTIFIER %s L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n", $1);}
				| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> IDENTIFIER %s L_SQUARE_BRACKET expression R_SQUARE_BRACKET L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n", $1);}
				;

%%

/* Additional C Code */
void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currpos, msg);
   }

int main(){
	yyparse();
}
