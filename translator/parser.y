%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  void yyerror(const char *s) {
  	fprintf(stderr, "Error: %s\n", s);
  }

  int yylex();

  enum Visibility { V_PRIVATE, V_PROTECTED, V_PUBLIC };
  enum Type { T_INT, T_DOUBLE, T_LONG };
%}

%union {
  char* str;
  int ival;
}

%token <ival> PRIVATE PUBLIC PROTECTED
%token <ival> INT DOUBLE LONG
%token <ival> PRIVATE_PY PROTECTED_PY PUBLIC_PY
%token <str> ID
%token <str> FLOATVAL INTVAL
%token EQUAL SEMICOLON NEWLINE

%type <ival> visibility py_visibility type
%type <str> value

%start translation

%%

translation:
  	cpp_to_py NEWLINE
	| py_to_cpp NEWLINE
	;

cpp_to_py:
	visibility type ID EQUAL value SEMICOLON {
  	printf("[DEBUG] C++ tokens: visibility=%d, type=%d, name=%s, value=%s\n", $1, $2, $3, $5);
  	const char* prefix = ($1 == V_PRIVATE) ? "__" : ($1 == V_PROTECTED) ? "_" : "";
  	printf("self.%s%s = %s\n", prefix, $3, $5);
	}
	;

py_to_cpp:
	py_visibility ID EQUAL value {
  	const char* ctype = strchr($4, '.') ? "double" : "int";
  	printf("[DEBUG] Python tokens: visibility=%d, name=%s, value=%s\n", $1, $2, $4);
  	if ($1 == V_PRIVATE)
    	printf("private %s %s = %s;\n", ctype, $2, $4);
  	else if ($1 == V_PROTECTED)
    	printf("protected %s %s = %s;\n", ctype, $2, $4);
  	else
    	printf("public %s %s = %s;\n", ctype, $2, $4);
	}
	;

visibility:
  	PRIVATE	{ $$ = $1; }
	| PROTECTED  { $$ = $1; }
	| PUBLIC 	{ $$ = $1; }
	;

py_visibility:
  	PRIVATE_PY	{ $$ = $1; }
	| PROTECTED_PY  { $$ = $1; }
	| PUBLIC_PY 	{ $$ = $1; }
	;

type:
  	INT 	{ $$ = $1; }
	| DOUBLE  { $$ = $1; }
	| LONG	{ $$ = $1; }
	;

value:
  	INTVAL   { $$ = $1; }
	| FLOATVAL { $$ = $1; }
	;

%%

int main() {
	return yyparse();
}
