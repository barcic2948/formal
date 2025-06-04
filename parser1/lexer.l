%option noyywrap

%{
  #include "parser.tab.h"
  #include <string.h>
  #include <stdio.h>
%}

%%

"int"               	{ return INT; }
"float"             	{ return FLOAT; }
"double"            	{ return DOUBLE; }
"char"              	{ return CHAR; }
"string"            	{ return STRING; }
"const"             	{ return CONST; }

"="                 	{ return EQUAL; }
";"                 	{ return SEMICOLON; }
"*"                 	{ return ASTERISK; }
"&"                 	{ return AMPERSAND; }
","                 	{ return COMMA; }
":"                 	{ return COLON; }
"("                 	{ return LPAREN; }
")"                 	{ return RPAREN; }
"\["                	{ return LBRACKET; }
"\]"                	{ return RBRACKET; }

\"[^\"]*\"          	{ yylval.str = strdup(yytext); return STRINGVAL; }
'[^']'              	{ yylval.str = strdup(yytext); return CHARVAL; }

[0-9]+\.[0-9]+      	{ yylval.str = strdup(yytext); return FLOATVAL; }
[0-9]+              	{ yylval.str = strdup(yytext); return INTVAL; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

"//".*              	; // skip single-line comments
"/*"([^*]|\*+[^*/])*\*+"/"   ; // skip multi-line comments

[ \t\r\n]+          	; // skip whitespace

.                   	{ return ERROR; }

%%

