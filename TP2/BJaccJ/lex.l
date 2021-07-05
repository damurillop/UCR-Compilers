%{
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    void yyerror(char *);
%}

%%

"AND"|"OR"|"XOR"|"ADD"|"SUB" { yylval.string=strdup(yytext);  return RRR;}
"CMP"|"NOT" { yylval.string=strdup(yytext);  return RR;}
"LOADI"|"SHIFT" { yylval.string=strdup(yytext);  return RI;}
"LOAD"|"STORE" { yylval.string=strdup(yytext);  return RPM;}
"JMP"|"BB"|"BEQ" { yylval.string=strdup(yytext);  return PM;}
"STOREI" { yylval.string=strdup(yytext);  return IPM;}
"NO OP" { yylval.string=strdup(yytext);  return NOP;}
","     {return COMA;}
"["     {return CORCHETEA;}
"]"     {return CORCHETEC;}
R((1[0-5])|[0-9]) { yylval.string=strdup(yytext);  return REG;}
(1[0-5])|([0-9]) { yylval.number = atoi(yytext);  return INM;}
"\n"      {return CL;}


%%

int yywrap(void){
    return 1; 
}