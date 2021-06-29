%{
    #include <stdlib.h>
    void yyerror(char *);
    #include "y.tab.h"
%}

%%

"AND"|"OR"|"XOR"|"ADD"|"SUB"  {return RRR;}
"CMP"| "NOT" {return RR;}
"LOADI"|"SHIFT" {return RI;}
"LOAD" | "STORE" {return RPM;}
"JMP"|"BB"|"BEQ" {return PM;}
"STOREI" {return IPM}
"NO OP" {return NOP}
R([0-9])|(1[0-5]) {return REG;}
(1[0-5])|[0-9]) {return INM}


%%

int yywrap(void){
    return 1; 
}