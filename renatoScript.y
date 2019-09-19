%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "renatoScriptBib.c"

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	float flo;
	int fn;
	int inter;
	Ast *a;
	char str[50];
	}

%token <flo>NUM
%token <str>VAR

%token INICIO
%token FIM 
%token SE 
%token SENAO
%token ENQUANTO
%token ESCREVER
%token LER
%token <fn> CMP
%right RAIZ
%right '='
%left '+' '-'
%left '*' '/'
%left '^'

%type <a> exp list stmt prog

%nonassoc IFX NEG

%%

val: INICIO prog FIM
	;

prog: stmt 		{eval($1);}  
	| prog stmt {eval($2);}	
	;
	
stmt: SE '(' exp ')' '{' list '}' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| SE '(' exp ')' '{' list '}' SENAO '{' list '}' {$$ = newflow('I', $3, $6, $10);}
	| ENQUANTO '(' exp ')' '{' list '}' {$$ = newflow('W', $3, $6, NULL);}
	| VAR '=' exp {insertList(list, $1); $$ = newasgn($1,$3);}
	| ESCREVER '(' exp ')' { $$ = newast('P',$3,NULL);}
	| LER '(' VAR ')' { $$ = newLer($3);}
	;

list:	  stmt{$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;
	
exp: 
	 exp '+' exp {$$ = newast('+',$1,$3);}		
	|exp '-' exp {$$ = newast('-',$1,$3);}
	|exp '*' exp {$$ = newast('*',$1,$3);}
	|exp '/' exp {$$ = newast('/',$1,$3);}
	|exp '^' exp {$$ = newast('^',$1,$3);}
	|exp RAIZ exp {$$ = newast('@', $1,$3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM {$$ = newnum($1);}						
	|VAR {$$ = newValorVal($1);}				

	;

%%

#include "lex.yy.c"

int main(){
	list = malloc(sizeof(struct estr));
	yyin=fopen("renatoScript","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}

