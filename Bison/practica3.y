%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yylex (void);
int yyerror(char *);
int obtenerSiguienteNumero();
%}
%union{
int num;
char * id;
int lbl;
}
%token COMA SUMA RESTA MULTIPLICACION DIVISION IGUAL OP CP
%token WHILE ENDWHILE IF THEN ELSEIF ELSE ENDIF PRINT INCREMENTO DECREMENTO
%token <num> NUM
%token <id> ID
%left  SUMA RESTA IGUAL
%left  MULTIPLICACION DIVISION

%%


stmtsequence:
	programstmt
	| programstmt stmtsequence
	;
	
programstmt:
	assigconstruct
	| loopconstruct
	| ifconstruct
	| printstmt
	;

loopconstruct: 
	WHILE {$<lbl>$ = obtenerSiguienteNumero(); printf("\nLBL%d", $<lbl>$);}
	OP expr CP 
	{$<lbl>$ = obtenerSiguienteNumero(); printf("\n\tsifalsovea LBL%d", $<lbl>$);}
	stmtsequence 
	ENDWHILE {printf("\n\tvea LBL%d\nLBL%d", $<lbl>2, $<lbl>6);}
	;

ifconstruct: 
	ifthenstmt stmtsequence elseifconstruct elseconstruct
	ENDIF {$<lbl>$ = obtenerSiguienteNumero(); printf("\nLBL%d", $<lbl>$-1);}
	;

ifthenstmt: 
	IF OP expr CP 
	{$<lbl>$ = obtenerSiguienteNumero(); printf("\n\tsifalsovea LBL%d", $<lbl>$);}
	THEN
	;

elseifconstruct:
	| elseifconstruct1
	;
	
elseifconstruct1:
	ELSEIF {$<lbl>$ = obtenerSiguienteNumero(); printf("\n\tvea LBL%d\nLBL%d", $<lbl>$, $<lbl>$);}
	OP expr CP {$<lbl>$ = obtenerSiguienteNumero(); printf("\n\tsifalsovea LBL%d", $<lbl>$);}
	THEN stmtsequence elseifconstruct
	;

elseconstruct:
	ELSE {$<lbl>$ = obtenerSiguienteNumero(); printf("\n\tvea LBL%d\nLBL%d", $<lbl>$, $<lbl>$-1);}
	stmtsequence
	| 
	;

printstmt:
	PRINT expr {printf("\n\tprint");} printstmt1
	;

printstmt1:
	| COMA expr {printf("\n\tprint");} printstmt1
	;

assigconstruct: 
	 ID IGUAL {printf("\n\tvalori %s",$1);} expr {printf("\n\tasigna");}
	| ID INCREMENTO{printf("\n\tvalori %s\n\tvalord %s\n\tmete 1\n \tsum\n \tasigna", $1, $1);}
	| ID DECREMENTO{printf("\n\tvalori %s\n\tvalord %s\n\tmete 1\n \tsub\n \tasigna", $1, $1);}
	;

expr: 
	expr SUMA multexp {printf("\n\tsum");}
	| expr RESTA multexp {printf("\n\tsub");}
	| multexp
	;

multexp: 
	multexp MULTIPLICACION value {printf("\n\tmul");}
	| multexp DIVISION value {printf("\n\tdiv");}
	| value
	;


value: 
	OP expr CP
	|NUM		{printf("\n\tmete %d", $1);}
	|ID		{printf("\n\tvalord %s", $1);}
	;
	
%%

int yyerror(char *s){
	printf("\nError %s\n",s);
	exit(-1);
}

//FUNCIÓN MAIN
int main( int argc, char *argv[] ){
        //Si no se puede abrir el fichero correctamente
	if (argc > 1){
		extern FILE *yyin;
		++argv;
		yyin = fopen( argv[0], "r" );
		if(!yyin) {
			fprintf(stderr, "Ha ocurrido un error al intentar abrir el fichero. %s\n", argv[1]);
			exit(1);
		}
		int errors = 0;
	}
        else{
                //Si se abre sin problemas
	        yyparse ();
	        printf("\n");
	        return 0;
        }
}

int obtenerSiguienteNumero(){
	static int siguienteNumero = 0;
	return siguienteNumero++;
}
	
