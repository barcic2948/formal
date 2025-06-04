%{
	#include <stdlib.h>
	#include <stdio.h>
	#include <iostream>
	#include <cmath>
    
	void yyerror(char *s);
	int yylex();
	extern FILE* yyin;

%}

%verbose

%union {
	double dval;
}

%token <dval> NUMBER PLUS MINUS TIMES DIVIDE POWER EQUAL SIN COS

%type <dval> expression term factor total

%left PLUS MINUS
%left TIMES DIVIDE
%right POWER

%%

total   	:   expression EQUAL            	{ std::cout <<  $1 << std::endl; }
        	;

expression  :   expression PLUS term            	{  $$ = $1 + $3;  }
        	|   expression MINUS term           	{  $$ = $1 - $3;  }
        	|   term                            	{  $$ = $1;  }
      	 
term    	:   term TIMES factor               	{  $$ = $1 * $3;  }
        	|   term DIVIDE factor {
           	if ($3 == 0) {
               	yyerror("Division by zero");
               	$$ = 0;
           	} else {
               	$$ = $1 / $3;
           	}
        	}
        	| factor                            	{  $$ = $1;  }
        	;

factor  	:   factor POWER factor             	{  $$ = pow($1, $3);  }
        	|   SIN '(' expression ')'          	{ $$ = sin($3);  }
        	|   COS '(' expression ')'          	{ $$ = cos($3);  }
        	|   NUMBER                          	{  $$ = $1;  }
        	|   '(' expression ')'              	{  $$ = $2;  }
        	;

%%

void yyerror(char *s)
{
	fprintf(stderr, "%s\n", s);
}

int main()
{
	std::ios_base::sync_with_stdio (true);
	yyparse();    
	return 0;
}
