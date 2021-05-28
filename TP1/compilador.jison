/* lexical grammar */
%lex
%%

\s+                             /* skip whitespace */
"declare"      			            return 'COMANDO'
"retorne"	                      return 'RETURN'
"array"|"variable"|"arreglo"		return 'TIPO'
"funcion"												return 'FUNCION'
"posicion"                      return 'POSICION'
parametros?                     return 'PARAMETRO'
"entre"                         return 'ENTRE'
"de"|"con "|"a"|"en"        					return 'ASIGNADOR'
"tamaño"              					return 'DIMENSION'
[0-9]+                					return 'LITERAL'
"sume"|"sumar"|"multiplique"|"reste"|"divida"		return 'OPERANDO'
"es igual"|"es menor"|"es menor o igual"|"es mayor o igual"|"es mayor"|"es diferente"                  return 'COMPARADOR'
"es"                 		        return 'PALABRACLAVE'
"sino"	                        return 'ELSE'
"si"|"mientras"                 return 'CONDICIONAL'
"entonces"               	      return 'TRANSICION'
"corchete"				              return 'CORCHETE'
"comente"								        return 'COMENTARIO'
"inicie"												return 'INICIE'
"termine" 											return 'TERMINE'
"linea nueva"|"nueva linea"			return 'NUEVALINEA'
[a-zA-Z_][0-9a-zA-Z_]*          return 'ID'
';'              		            return 'FINAL'
','															return 'COMA'
'.' 														return 'PUNTO'
.                     					return 'INVALID'

/lex

%start S
 
%% /* GRAMATICA */

S:L         
  { typeof console !== 'undefined' ? console.log($1) : print($1); return $1; } ;

L:I FINAL L{$$ = $1 + ' ' + $3;} | I FINAL;
I: 
    COMANDO TIPO ID
        {$$ = "var" + $3 + ";";}
    |COMANDO TIPO ID ASIGNADOR DIMENSION LITERAL 
				{$$ = "var "+$3+"["+$6+"];";}
    | OPERANDO LITERAL ASIGNADOR TIPO ID 
      {
        if($1== 'multiplique'){
        		{$$ = $5 +" *= "+$2+";";}
				}else if($1 == 'sume'){
            {$$ = $5 +" += "+$2+";";}
        }else if($1 == 'reste'){
            {$$ = $5 +" -= "+$2+";";}
        }else{
          {$$ = "";}
        }
      }
    | OPERANDO ENTRE LITERAL ASIGNADOR TIPO ID
      {
        if($1 == 'divida'){
          {$$ = $6 +" /= "+$3+";";}
        }else {
          {$$ = "";}
        }
      }
    | ELSE
    	 {$$ = "else {";}
    |  TIPO ID PALABRACLAVE LITERAL
       {$$ = $2 + " = " + $4 + ";"}
    |  TIPO ID C ASIGNADOR LITERAL
       {$$ = $2 + $3 + $5}
    | CONDICIONAL TIPO ID C ASIGNADOR LITERAL TRANSICION 
    	{
      	if($1 == "si"){
        	$$ = "if";
        }else if($1 == "mientras"){
        	$$ = "while";
        }
        $$ +="("+$3+$4+$6+"){";
      }
  	| COMANDO FUNCION ID 
    	  {$$ = "function "+$3+"(){"}
    | COMANDO FUNCION ID ASIGNADOR PARAMETRO P
    		{$$ = "function "+$3+"("+$6+"){"}
    | RETURN TIPO ID 
        {$$ = "return "+$3+";";}
    | RETURN POSICION LITERAL ASIGNADOR TIPO ID
        {if($4 == "de"){
          $$ = "return "+$6+"["+$3+"];";
        }else{
          $$ = "";
        };}
    | TIPO ID PALABRACLAVE TIPO ID ASIGNADOR POSICION LITERAL
       {if($1 == "variable" && $6 == "en"){
         $$ = "var " + $2 + " = " + $5 + "[" + $8 + "];";
       }else{
         $$ = "";
       };} 
    | TERMINE CORCHETE  
    		{$$ = "}";}
    | COMENTARIO Q
    		{$$ = "//"+$2;}
    | NUEVALINEA
				{$$ = "\n"}
   ​;
P:  ID COMA P {$$ = $1 + ", " + $3;} | ID {$$ = $1;};
C: COMPARADOR
	{
  	if ($1 == "es igual"){
    	{$$ = " == "}
    }else if($1 == "es diferente"){
      {$$ = " != "}
    }else if($1 == "es menor"){
    	{$$ = " < "}
    }else if($1 == "es menor o igual"){
    	{$$ = " <= "}
    }else if($1 == "es mayor o igual"){
    	{$$ = " >= "}
    }else if($1 == "es mayor"){
    	{$$ = " > "}
    }
  };
Q: ID Q {$$= $1 + " " + $2;} 
	| COMA Q {$$ = $1 + " " + $2;} 
	| LITERAL Q {$$ = $1 + " " + $2}
  | PUNTO Q {$$ = $1 + " " + $2}
  | COMA {$$ = $1}| LITERAL{$$ = $1} |ID{$$=$1} | PUNTO{$$=$1};
  