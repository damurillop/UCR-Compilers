%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    void yyerror(const char *);
    char * decABinario(int);
    char * getRegToBin(char *);
%}

%token COMA
%token CORCHETEA
%token CORCHETEC
%token CL

%union {
    char* string;
    int number;
}

%token <number> INM
%token <string> REG
%token <string> RRR
%token <string> RR
%token <string> RI
%token <string> RPM
%token <string> PM
%token <string> IPM
%token <string> NOP


%%

start: S ;

S: S I CL { printf("\n");}
| I CL { printf("\n"); };
| S I;

I: RRR REG COMA REG COMA REG { 
        if(!strcmp($1, "ADD")){
                printf("1100%s%s%s", getRegToBin($2), getRegToBin($4), getRegToBin($6));
        }else if(!strcmp($1, "SUB")){
                printf("1101%s%s%s", getRegToBin($2), getRegToBin($4), getRegToBin($6));
        }else if(!strcmp($1, "AND")){
                printf("1000%s%s%s", getRegToBin($2), getRegToBin($4), getRegToBin($6));
        }else if(!strcmp($1, "OR")){
                printf("1001%s%s%s", getRegToBin($2), getRegToBin($4), getRegToBin($6));
        }else if(!strcmp($1, "XOR")){
                printf("1010%s%s%s", getRegToBin($2), getRegToBin($4), getRegToBin($6));
        }
    }
    | RR REG COMA REG{
        if(!strcmp($1, "CMP")){
            printf("1111%s%s%s", getRegToBin($2), getRegToBin($4),"0000");
        }else if(!strcmp($1,"NOT")){
            printf("1011%s%s%s", getRegToBin($2) , "0000" , getRegToBin($4));
        }
    }
    | RI REG COMA INM {
        if(!strcmp($1,"LOADI")){
            printf("0011%s%s%s", getRegToBin($2), decABinario($4), "0000");
        }else if(!strcmp($1, "SHIFT")){
            printf("1110%s%s%s", getRegToBin($2), decABinario($4), "0000");
        }
    }
    | RPM REG COMA CORCHETEA INM CORCHETEC {
        if(!strcmp($1,"LOAD")){
            printf("0001%s%s%s",getRegToBin($2),"0000",decABinario($5));
        }else if(!strcmp($1,"STORE")){
            printf("0010%s%s%s",getRegToBin($2),"0000",decABinario($5));
        }
    }
    | PM COMA CORCHETEA INM CORCHETEA {
        if(!strcmp($1, "JMP")){
            printf("0101%s%s%s","0000","0000",decABinario($4));
        }else if(!strcmp($1, "BB")){
            printf("0110%s%s%s","0000","0000",decABinario($4));
        }else if(!strcmp($1, "BEQ")){
            printf("0111%s%s%s","0000","0000",decABinario($4));
        }
    }
    | IPM INM COMA CORCHETEA INM CORCHETEC {
        if(!strcmp($1,"STOREI")){
            printf("0100%s%s%s","0000",decABinario($2),decABinario($5));
        }
    }
    |NOP {
        printf("0000000000000000");
    };

%%

int main(void){
    yyparse();
    return 0; 
}

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}
char * getRegToBin(char * reg){
    int regN = atoi(&reg[1]);
    return decABinario(regN);
}
char *decABinario(int n)
{
  int c, d, t;
  char *p;

  t = 0;
  p = (char*)malloc(3+1);

  if (p == NULL)
    exit(EXIT_FAILURE);

  for (c = 3 ; c >= 0 ; c--)
  {
    d = n >> c;

    if (d & 1)
      *(p+t) = 1 + '0';
    else
      *(p+t) = 0 + '0';

    t++;
  }
  *(p+t) = '\0';
  return  p;
}
