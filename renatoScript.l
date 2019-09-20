%{

%}

SE "se"
SENAO "senao"
ENQUANTO "enquanto"
ESCREVER "escrever"
LER "ler"
INICIO "INICIO"
FIM "FIM"
TIPO ("int"|"double"|"float")
INT [0-9]+
VAR [A-Za-z]+[0-9A-Za-z]*
CARACTER ("&")
COMENTARIO ("#")((.)|{IGNORE})*("/#")
STR ["].*["]
IGNORE ("\t"|"\n"|" ")
INVALIDO (.)
NUM [0-9]+\.?[0-9]*
RAIZ "@"
%%

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"!=" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }
{INICIO} {return INICIO;}
{FIM} {return FIM;}
{SE} {return SE;}
{SENAO} {return SENAO;}
{ENQUANTO} {return ENQUANTO;}
{ESCREVER} {return ESCREVER;}
{LER} {return LER;}
{RAIZ} {return RAIZ;}
{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
	}
{VAR} {
	strcpy(yylval.str, yytext);
	return VAR;
	}

[-+()=/*^{};] { return *yytext; }


[\ \n\t]*	{;}

. {}
%%