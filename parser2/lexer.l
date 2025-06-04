%option noyywrap

%{
#include "parser.tab.h"
#include <cstdio>
#include <cstring>

extern int yylineno;
%}


%%

"int"       { printf("INT "); return INT; }
"char"      { printf("CHAR "); return CHAR; }
"double"    { printf("DOUBLE "); return DOUBLE; }

[0-9]+      { printf("INVALID_ID "); return INVALID_ID; }

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("IDENTIFIER ");
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

"("         { printf("LPAREN "); return LPAREN; }
")"         { printf("RPAREN "); return RPAREN; }
","         { printf("COMMA "); return COMMA; }
";"         { printf("SEMICOLON "); return SEMICOLON; }
"*"         { printf("STAR "); return STAR; }

"//".*      { printf("COMMENT "); }
"/*"([^*]|\*+[^*/])*\*+"/"   { printf("COMMENT "); }

[ \t\r]+    {printf("TABS ");}

\n          {printf("NEWLINE \n");}

.           {
    printf("TOKEN(%s) ", yytext);
    return UNKNOWN;
}

%%
