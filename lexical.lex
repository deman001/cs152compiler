%option nounput yylineno

%%
function	return FUNCTION;
beginparams	return BEGIN_PARAMS;
endparams	return END_PARAMS;
beginlocals	return BEGIN_BODY;
endbody		return END_BODY
integer		return INTEGER;
%%
