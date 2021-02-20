/* CS152 Project Phase 1 */
 /* A flex scanner specification for the MINI-L language */
 /* Written by Johnny Vo and Dale Eman */

%{
	#include "y.tab.h"
	int currLine = 1;
	int currpos = 1;
%}

 /* DEFINITIONS */
DIGIT	[0-9]
LETTER	[a-zA-Z]
IDENTIFIER [a-zA-Z][_0-9a-zA-Z]*


%%

 /* RESERVED KEYWORDS */

function	{currpos += yyleng; return FUNCTION;}
beginparams	{currpos += yyleng; return BEGIN_PARAMS;}
endparams	{currpos += yyleng; return END_PARAMS;}
beginlocals 	{currpos += yyleng; return BEGIN_LOCALS;}
endlocals	{currpos += yyleng; return END_LOCALS;}
beginbody	{currpos += yyleng; return BEGIN_BODY;}
endbody		{currpos += yyleng; return END_BODY;}
integer		{currpos += yyleng; return INTEGER;}
array		{currpos += yyleng; return ARRAY;}
of		{currpos += yyleng; return OF;}
if		{currpos += yyleng; return IF;}
then		{currpos += yyleng; return THEN;}
endif		{currpos += yyleng; return ENDIF;}
else		{currpos += yyleng; return ELSE;}
while		{currpos += yyleng; return WHILE;}
do		{currpos += yyleng; return DO;}
beginloop	{currpos += yyleng; return BEGINLOOP;}
endloop		{currpos += yyleng; return ENDLOOP;}
break		{currpos += yyleng; return BREAK;}
read		{currpos += yyleng; return READ;}
write		{currpos += yyleng; return WRITE;}
and		{currpos += yyleng; return AND;}
or		{currpos += yyleng; return OR;}
not		{currpos += yyleng; return NOT;}
true		{currpos += yyleng; return TRUE;}
false		{currpos += yyleng; return FALSE;}
return		{currpos += yyleng; return RETURN;}

 /* ARITHMETIC OPERATORS */

"-"		{currpos += yyleng; return SUB;}
"+"		{currpos += yyleng; return ADD;}
"*"		{currpos += yyleng; return MULT;}
"/"		{currpos += yyleng; return DIV;}
"%"		{currpos += yyleng; return MOD;}

 /* COMPARISON OPERATORS */

"=="		{currpos += yyleng; return EQ;}
"<>"		{currpos += yyleng; return NEQ;}
"<"		{currpos += yyleng; return LT;}
">"		{currpos += yyleng; return GT;}
"<="		{currpos += yyleng; return LTE;}
">="		{currpos += yyleng; return GTE;}

 /* OTHER SPECIAL SYMBOLS */

";"		{currpos += yyleng; return SEMICOLON;}
":"		{currpos += yyleng; return COLON;}
","		{currpos += yyleng; return COMMA;}
"("		{currpos += yyleng; return L_PAREN;}
")"		{currpos += yyleng; return R_PAREN;}
"["		{currpos += yyleng; return L_SQUARE_BRACKET;}
"]"		{currpos += yyleng; return R_SQUARE_BRACKET;}
":="		{currpos += yyleng; return ASSIGN;}

 /* IDENTIFIERS, NUMBERS, ERRORS */
{DIGIT}+		{currpos += yyleng; yylval.val = atoi(yytext); return NUMBER;}
{DIGIT}+{IDENTIFIER}+	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currpos, yytext); exit(1);}
_+{IDENTIFIER}+		{printf("Error at line %d, column %d: identifer \"%s\" must begin with a letter\n", currLine, currpos, yytext); exit(1);}
{IDENTIFIER}*_		{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currpos, yytext); exit(1);}
{IDENTIFIER}		{currpos += yyleng; strcpy(yylval.id, yytext); return IDENTIFIER;}

 /* ETC */
[ \r\t]			{currpos += yyleng;}
\n			{currpos = 1; currLine++;}
[##][^\n]*\n		{currpos = 1; currLine++;}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currpos, yytext); exit(1);}

%%


