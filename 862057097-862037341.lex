/* CS152 Project Phase 1 */
 /* A flex scanner specification for the MINI-L language */
 /* Written by Johnny Vo and Dale Eman */

%{
	int currLine = 1;
	int currpos = 1;
%}

 /* DEFINITIONS */
DIGIT	[0-9]
LETTER	[a-zA-Z]
IDENTIFIER [a-zA-Z][_0-9a-zA-Z]*


%%

 /* RESERVED KEYWORDS */

function	{printf("FUNCTION\n"); currpos += yyleng;}
beginparams	{printf("BEGIN_PARAMS\n"); currpos += yyleng;}
endparams	{printf("END_PARAMS\n"); currpos += yyleng;}
beginlocals {printf("BEGIN_LOCALS\n"); currpos += yyleng;}
endlocals	{printf("END_LOCALS\n"); currpos += yyleng;}
beginbody	{printf("BEGIN_BODY\n"); currpos += yyleng;}
endbody		{printf("END_BODY\n"); currpos += yyleng;}
integer		{printf("INTEGER\n"); currpos += yyleng;}
array		{printf("ARRAY\n"); currpos += yyleng;}
of			{printf("OF\n"); currpos += yyleng;}
if			{printf("IF\n"); currpos += yyleng;}
then		{printf("THEN\n"); currpos += yyleng;}
endif		{printf("ENDIF\n"); currpos += yyleng;}
else		{printf("ELSE\n"); currpos += yyleng;}
while		{printf("WHILE\n"); currpos += yyleng;}
do			{printf("DO\n"); currpos += yyleng;}
beginloop	{printf("BEGINLOOP\n"); currpos += yyleng;}
endloop		{printf("ENDLOOP\n"); currpos += yyleng;}
break		{printf("BREAK\n"); currpos += yyleng;}
read		{printf("READ\n"); currpos += yyleng;}
write		{printf("WRITE\n"); currpos += yyleng;}
and			{printf("AND\n"); currpos += yyleng;}
or			{printf("OR\n"); currpos += yyleng;}
not			{printf("NOT\n"); currpos += yyleng;}
true		{printf("TRUE\n"); currpos += yyleng;}
false		{printf("FALSE\n"); currpos += yyleng;}
return		{printf("RETURN\n"); currpos += yyleng;}

 /* ARITHMETIC OPERATORS */

"-"			{printf("SUB\n"); currpos += yyleng;}
"+"			{printf("ADD\n"); currpos += yyleng;}
"*"			{printf("MULT\n"); currpos += yyleng;}
"/"			{printf("DIV\n"); currpos += yyleng;}
"%"			{printf("MOD\n"); currpos += yyleng;}

 /* COMPARISON OPERATORS */

"=="			{printf("EQ\n"); currpos += yyleng;}
"<>"			{printf("NEQ\n"); currpos += yyleng;}
"<"				{printf("LT\n"); currpos += yyleng;}
">"				{printf("GT\n"); currpos += yyleng;}
"<="			{printf("LTE\n"); currpos += yyleng;}
">="			{printf("GTE\n"); currpos += yyleng;}

 /* OTHER SPECIAL SYMBOLS */

";"				{printf("SEMICOLON\n"); currpos += yyleng;}
":"				{printf("COLON\n"); currpos += yyleng;}
","				{printf("COMMA\n"); currpos += yyleng;}
"("				{printf("L_PAREN\n"); currpos += yyleng;}
")"				{printf("R_PAREN\n"); currpos += yyleng;}
"["				{printf("L_SQUARE_BRACKET\n"); currpos += yyleng;}
"]"				{printf("R_SQUARE_BRACKET\n"); currpos += yyleng;}
":="			{printf("ASSIGN\n"); currpos += yyleng;}

 /* IDENTIFIERS, NUMBERS, ERRORS */
{DIGIT}+		{printf("NUMBER %s\n", yytext); currpos += yyleng;}
{DIGIT}+{IDENTIFIER}+	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currpos, yytext); exit(1);}
_+{IDENTIFIER}+	{printf("Error at line %d, column %d: identifer \"%s\" must begin with a letter\n", currLine, currpos, yytext); exit(1);}
{IDENTIFIER}*_	{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currpos, yytext); exit(1);}
{IDENTIFIER}*	{printf("IDENT %s\n", yytext); currpos += yyleng;}

 /* ETC */
[ \r\t]		{currpos += yyleng;}
\n			{currpos = 1; currLine++;}
[##][^\n]*\n		{currpos = 1; currLine++;}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currpos, yytext); exit(1);}

%%

int main(int argc, char** argv){
	yylex();
}
