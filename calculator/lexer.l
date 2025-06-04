%option noyywrap

%{
   #include "parser.tab.h"
   #include <stdlib.h>
   #include <iostream>
	#include "parser.tab.h"
%}
 
%%

[0-9]+(\.[0-9]+)?  { yylval.dval = atof(yytext); return NUMBER; }
"sin"      	return SIN;
"cos"      	return COS;
"*"        	return TIMES;
"+"        	return PLUS;
"-"        	return MINUS;
"/"        	return DIVIDE;
"**"       	return POWER;
=          	return EQUAL;
"("        	return '(';
")"        	return ')';
[ \t\n]    	{ }
.          	{ }
         	 

%%

