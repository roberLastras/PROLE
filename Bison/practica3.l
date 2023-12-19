%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}
%%

"while"		return WHILE;
"endwhile"	return ENDWHILE;
"if"		return IF;
"then"		return THEN;
"elseif"	return ELSEIF;
"else"		return ELSE;
"endif"		return ENDIF;
"print"		return PRINT;
"++"		return INCREMENTO;
"--"		return DECREMENTO;
"+"		return SUMA;
"-"		return RESTA;
"/"		return DIVISION;
"*"		return MULTIPLICACION;
"="		return IGUAL;
","		return COMA;
"("		return OP;
")"		return CP;
"!".*		;
\n		;
\r		;
\t		;
" "		;
[0-9]+		{yylval.num = atoi(yytext); return NUM; };
([a-zA-Z]|["_"])+([a-zA-Z0-9]|["_"])*	{yylval.id = strdup(yytext); return ID;};
.		return yytext[0];

%%
