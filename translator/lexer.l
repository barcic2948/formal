%option noyywrap

%{
  #include "parser.tab.h"
  #include <string.h>
  #include <stdio.h>

  enum Visibility { V_PRIVATE, V_PROTECTED, V_PUBLIC };
  enum Type { T_INT, T_DOUBLE, T_LONG };
%}

%%

"private"   	{ yylval.ival = V_PRIVATE; printf("[LEXER] Token: private\n"); return PRIVATE; }
"public"    	{ yylval.ival = V_PUBLIC;  printf("[LEXER] Token: public\n");  return PUBLIC; }
"protected" 	{ yylval.ival = V_PROTECTED; printf("[LEXER] Token: protected\n"); return PROTECTED; }

"int"       	{ yylval.ival = T_INT; 	printf("[LEXER] Token: int\n"); 	return INT; }
"double"    	{ yylval.ival = T_DOUBLE;  printf("[LEXER] Token: double\n");  return DOUBLE; }
"long"      	{ yylval.ival = T_LONG;	printf("[LEXER] Token: long\n");	return LONG; }

"self.__"   	{ yylval.ival = V_PRIVATE; printf("[LEXER] Token: self.__\n"); return PRIVATE_PY; }
"self._"    	{ yylval.ival = V_PROTECTED; printf("[LEXER] Token: self._\n"); return PROTECTED_PY; }
"self."     	{ yylval.ival = V_PUBLIC;  printf("[LEXER] Token: self.\n");   return PUBLIC_PY; }

[0-9]+\.[0-9]+  { yylval.str = strdup(yytext); printf("[LEXER] FLOATVAL: %s\n", yytext); return FLOATVAL; }
[0-9]+      	{ yylval.str = strdup(yytext); printf("[LEXER] INTVAL: %s\n", yytext); return INTVAL; }

[a-zA-Z_][a-zA-Z_0-9]* { yylval.str = strdup(yytext); printf("[LEXER] ID: %s\n", yytext); return ID; }

"="         	{ printf("[LEXER] Token: =\n"); return EQUAL; }
";"         	{ printf("[LEXER] Token: ;\n"); return SEMICOLON; }
\n          	{ printf("[LEXER] Token: \\n\n"); return NEWLINE; }
[ \t]+      	/* skip whitespace */ ;
.           	/* ignore other characters */ ;

%%
