%{
    #include <stdio.h>
    void yyerror(const char *);
%}

//%error-verbose
%token REG INM RRR RR RI RPM PM IPM NOP CL


%%

start: S {return $1};

S: S I CL { $$ = $1 + '\n' + $2;} | I CL { $$ = $1;};

I: RRR A{ 
    switch($1){
        case "ADD":
            $$ = "1100" + $2;
        break;
        case "SUB":
            $$ = "1101" + $2;
        break;
        case "AND":
            $$ = "1000" + $2;
        break;
        case "OR":
            $$ = "1001" + $2;
        break;
        case "ADD":
            $$ = "1010" + $2;
    }
} | RR B{
    switch($1){
        case "CMP":
            $$ = "1111" + $2;
        break;
        case "NOT":
            $$ = "1011" + $2;
        break;
    }
} | RI C {
    switch($1){
        case "LOADI": 
            $$ = "0011" + $2;
        break;
        case "SHIFT":
            $$ = "1110" + $2;
        break;

    }
    
}| RPM D {
    switch($1){
        case "LOAD":
            $$ = "0001" + $2;
        break;
        case "STORE":
            $$ = "0010" + $2;
        break;
    }
}| PM E {
    switch($1){
        case "JMP":
            $$ = "0101" + $2;
        break;
        case "BB":
            $$ = "0110" + $2;
        break;
        case "BEQ":
            $$ = "0111" + $2;
        break;
    }
}| IPM F {
    swtich($1){
        case "STOREI":
            $$ = "0100" + $2;
        break; 
    }
    
}| NOP {
    $$ = "0000000000000000"; 
};
A: REG ',' REG { 
        $$ = decABinario($1) + decABinario($3);
};


B: REG ',' REG ',' REG {
    $$ = decABinario($1) + decABinario($3) + decABinario($5);
 };
C: REG ',' INM {
    $$ = decABinario($1) + decABinario($3);
 };
D: REG ',' '[' INM ']' {
    $$ = decABinario($1) + decABinario($3);
};
E: '[' INM ']' { ... } {
    $$ = decABinario($1);
}
F: INM ',' '[' INM ']' { $$ = "0000" + decABinario($1) + decABinario($3)};

"AND"|"OR"|"XOR"|"ADD"|"SUB"  {return RRR;}
"CMP"| "NOT" {return RR;}
"LOADI"|"SHIFT" {return RI;}

"LOAD" | "STORE" {return RPM;}
"JMP"|"BB"|"BEQ" {return PM;}
"STOREI" {return IPM}
"NO OP" {return NOP}

%%

int main(void){
    yyparse();
    printf("Good");
    return 0; 
}

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    return 1; 
}

char * decABinario(int num){
    int numBinario[4];
    char * stringBinario[4];
    int i = 0; 
    while(n > 0){
        binaryNum[i] = n%2;
        n = n/2
        i++;
    }
    for(int j = 0; j < 4; j++){
        stringBinario[j] = numBinario[i] + '0';
    }
    return stringBinario;
}
