/* CS152 Project Phase 3 			  */
/* Mini-l Bison Parser 	& Code Generator	  */
/* Written by Johnny Vo and Dale Eman */

/* C Declarations */
%{
#include <stdio.h>
#include <stdlib.h>
#include <sstream>
void yyerror(const char *msg);
int yylex(void);
extern int currLine;
extern int currpos;
extern char* yytext;
struct Statement_IR{
	std::string IR;
	}
struct Expression_IR{
	std::string IR;
	std::string ret_name;
	}
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
prog_start:			function_loop;

function_loop:			/*epsilon*/ 
				| function_loop FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declaration_loop END_PARAMS BEGIN_LOCALS declaration_loop END_LOCALS BEGIN_BODY statement_loop END_BODY
				;
				
declaration_loop: 		/*epsilon*/ 
				| declaration_loop declaration SEMICOLON
				;
declaration:			identity_loop COLON array INTEGER
				;
identity_loop:			IDENTIFIER
				| identity_loop COMMA IDENTIFIER
				;
statement_loop:			statement SEMICOLON
				| statement_loop statement SEMICOLON
				;
array:				/*epsilon*/ 
				| ARRAY L_SQUARE_BRACKET NUMBER  R_SQUARE_BRACKET OF
				| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF
				;
statement:			assignment
				| if
				| while
				| do
				| for
				| read
				| write
				| break
				| return
				;
assignment:			var ASSIGN expression
				;
if:				IF bool_expr THEN statement_loop else ENDIF {
					string label0 = make_label();
					string label1 = make_label();
					stringstream ss;
					ss <<
				;
else:				/*epsilon*/ 
				| ELSE statement_loop
				;
while:				WHILE bool_expr BEGINLOOP statement_loop ENDLOOP
				;
do:				DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr
				;
for:				FOR var ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON var ASSIGN expression BEGINLOOP statement_loop ENDLOOP
				;
read:				READ var_loop
				;
write:				WRITE var_loop
				;
break:				BREAK
				;
return:				RETURN expression
var_loop:			var
				| var_loop COMMA var
				;
bool_expr:			rel_and_expr
				| bool_expr OR rel_and_expr
				;
rel_and_expr:			rel_expr
				| rel_and_expr AND rel_expr
				;
rel_expr:			rel_expr_og
				| NOT rel_expr_og
				;
rel_expr_og:			expression comp expression
				| TRUE
				| FALSE
				| L_PAREN bool_expr R_PAREN
				;
comp:           		EQ
               			| NEQ
				| LT
				| GT
				| LTE
				| GTE
				;
expression:			mult_expr
				| expression ADD mult_expr
				| expression SUB mult_expr
				;
mult_expr:			term_loop
				| mult_expr MULT term_loop
				| mult_expr DIV term_loop
				| mult_expr MOD term_loop
				;
term_loop:			term
				| SUB term %prec UMINUS
				| IDENTIFIER L_PAREN param_loop R_PAREN
				;
term:				var
				| NUMBER
				| L_PAREN expression R_PAREN
				;
param_loop:			/*epsilon*/ 
				| expr_loop 
				;
expr_loop:			expression 
				| expr_loop COMMA expression
				;
var:				IDENTIFIER
				| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET
				| IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET L_SQUARE_BRACKET expression R_SQUARE_BRACKET
				;

%%

/* Additional C Code */
void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currpos, msg);
   }

int main(){
	yyparse();
}
