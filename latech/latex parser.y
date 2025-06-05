%{
#include <iostream>
#include <fstream>
#include <set>
#include <stack>
#include <string>
#include <vector>

extern int yylex();
extern int yylineno;
extern char *yytext;

int error_in_line = 0;

void yyerror(const char *s) {
    error_in_line = 1;
}

std::ofstream output("out.txt");
int output_line_num = 0;

std::set<std::string> bibitems;
std::vector<std::string> cited_labels;
std::stack<int> quote_stack;

void print_result() {
    output_line_num++;
    if (error_in_line) {
        output << "line " << output_line_num << ": ERROR" << std::endl;
    } else {
        output << "line " << output_line_num << ": OK" << std::endl;
    }
    error_in_line = 0;
}
%}

%code requires {
  #include <string>
}

%union {
    std::string *sval;
}

%token <sval> T_CITE T_BIBITEM
%token T_BEGIN_QUOTE T_END_QUOTE T_NEWLINE

%start program

%%

program:
    /* empty */
    | program line
    ;

line:
      items T_NEWLINE  {
                          // unmatched quote
                          if (!quote_stack.empty()) {
                              error_in_line = 1;
                          }
                          print_result();
                          // clear for next line
                          while (!quote_stack.empty()) quote_stack.pop();
                       }
    | T_NEWLINE         { print_result(); }
    | error T_NEWLINE   { error_in_line = 1; print_result(); yyerrok; }
    ;

items:
    /* empty */
    | items item
    ;

item:
      T_BEGIN_QUOTE { quote_stack.push(1); }
    | T_END_QUOTE {
          if (!quote_stack.empty()) {
              quote_stack.pop();
          } else {
              error_in_line = 1;
          }
      }
    | T_CITE {
          cited_labels.push_back(*$1);
          delete $1;
      }
    | T_BIBITEM {
          bibitems.insert(*$1);
          delete $1;
      }
    ;
%%

int main() {
    extern FILE *yyin;
    yyin = fopen("in.txt", "r");
    if (!yyin) {
        std::cerr << "Failed to open in.txt\n";
        return 1;
    }

    yyparse();

    // Final pass: validate all cited labels are defined
    for (const auto& label : cited_labels) {
        if (bibitems.find(label) == bibitems.end()) {
            std::cerr << "Missing bibitem for citation: " << label << std::endl;
            // You could also append this to out.txt if desired
        }
    }

    std::cout << "Results written to out.txt\n";
    return 0;
}
