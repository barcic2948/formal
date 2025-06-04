{%
#include <cstdio>
#include <cstdlib>
#include <cstring>

extern int yylex();
extern void yyerror(const char *s);
extern void yyrestart(FILE*);
extern void yylex_destroy();
extern int yylineno;
extern void* yy_scan_string(const char *str);

bool parseSuccess = false;
FILE* outputFile;
%}

%union {
    char* str;
}

%token <str> IDENTIFIER
%token <str> INVALID_ID
%token INT CHAR DOUBLE
%token LPAREN RPAREN COMMA SEMICOLON STAR
%token UNKNOWN
%token NEWLINE

%start line

%%

line:
    declaration SEMICOLON NEWLINE { parseSuccess = true; }
    | declaration SEMICOLON       { parseSuccess = true; }
    | error NEWLINE               { parseSuccess = false; YYABORT; }
    | error                       { parseSuccess = false; YYABORT; }
    ;

declaration:
      type ptr_opt IDENTIFIER
    | type ptr_opt IDENTIFIER LPAREN param_list_opt RPAREN
    | type ptr_opt INVALID_ID           {  printf ("\nMatched rule: type ptr_opt INVALID_ID\n"); parseSuccess = false; YYABORT; }
    | type ptr_opt error                {  printf ("\nMatched rule: type ptr_opt error\n"); parseSuccess = false; YYABORT; }
    | type error                        {  printf ("\nMatched rule: type error\n"); parseSuccess = false; YYABORT; }
    ;

ptr_opt:
      /* empty */
    | STAR
    ;

type:
      INT
    | CHAR
    | DOUBLE
    | error { parseSuccess = false; YYABORT; }
    ;

param_list_opt:
      /* empty */
    | param_list
    ;

param_list:
      param
    | param_list COMMA param
    ;

param:
      type IDENTIFIER
    | type error         { parseSuccess = false; YYABORT; }
    ;

%%

void yyerror(const char *s) {
    parseSuccess = false;
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    FILE* input = fopen("input.c", "r");
    outputFile = fopen("output.txt", "w");
    if (!input || !outputFile) {
        perror("File error");
        return 1;
    }

    char line[1024];
    while (fgets(line, sizeof(line), input)) {
        printf("Parsing line: %s", line);
        yy_scan_string(line);
        parseSuccess = false;
        yyparse();
        yylex_destroy();
        printf("Line result: %s\n\n", parseSuccess ? "OK" : "ERROR");
        fprintf(outputFile, "%s\n", parseSuccess ? "OK" : "ERROR");
    }

    fclose(input);
    fclose(outputFile);
    return 0;
}
