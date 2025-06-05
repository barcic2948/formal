%{
#include <string>
#include <iostream>

#include "parser.tab.h"

extern int yylineno;
extern YYSTYPE yylval;

void yyerror(const char *s);
%}

%%

[ \t\r]+                ;

"\\begin{quote}"        { return T_BEGIN_QUOTE; }
"\\end{quote}"          { return T_END_QUOTE; }

"\\cite{"[^}]*"}"       {
                            std::string text(yytext);
                            size_t start = text.find('{') + 1;
                            size_t end = text.find('}');
                            yylval.sval = new std::string(text.substr(start, end - start));
                            return T_CITE;
                        }

"\\bibitem{"[^}]*"}"     {
                            std::string text(yytext);
                            size_t start = text.find('{') + 1;
                            size_t end = text.find('}');
                            yylval.sval = new std::string(text.substr(start, end - start));
                            return T_BIBITEM;
                        }

\n                      { yylineno++; return T_NEWLINE; }

.                       ; // Ignore other characters

%%

int yywrap() { return 1; }
