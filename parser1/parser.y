%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  void yyerror(const char *s) {
	printf("ERROR\n");
  }

  int yylex();
  int yyparse();
%}

%union {
  char* str;
}

%token CONST INT FLOAT DOUBLE CHAR STRING
%token <str> ID
%token <str> INTVAL FLOATVAL STRINGVAL CHARVAL
%token EQUAL SEMICOLON COMMA COLON
%token ASTERISK AMPERSAND
%token LPAREN RPAREN LBRACKET RBRACKET
%token ERROR

%start program

%%

program:
	/* empty */
  | program line
  ;

line:
	decl SEMICOLON { printf("OK\n"); }
  | error SEMICOLON { yyerror("Invalid declaration"); yyerrok; }
  ;

decl:
	type type_suffix ID LPAREN param_list RPAREN
  ;

type:
	const_qualifiers type_base
  ;

const_qualifiers:
	/* empty */
  | const_qualifiers CONST
  ;

type_base:
	INT
  | FLOAT
  | DOUBLE
  | CHAR
  | STRING
  ;

type_suffix:
	/* empty */
  | pointer_or_ref type_suffix
  ;

pointer_or_ref:
	ASTERISK
  | AMPERSAND
  ;

param_list:
	/* empty */
  | params
  ;

params:
	param
  | params COMMA param
  ;

param:
	type type_suffix array_part_opt ID_opt
  ;

array_part_opt:
	/* empty */
  | LBRACKET array_size_opt RBRACKET
  ;

array_size_opt:
	/* empty */
  | INTVAL
  ;

ID_opt:
	/* empty */
  | ID
  ;

%%

int main() {
	return yyparse();
}
