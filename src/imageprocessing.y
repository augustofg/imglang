%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>
#include <string.h>

void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
  float   numval;
}
%token <strval> STRING
%token <ival> VAR IGUAL EOL ASPA
%token <numval> NUMERO
%token MULTIPLICAR DIVIDIR ABRE_COL FECHA_COL

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING
	{
        dbgmsg("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        dbgmsg("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
		liberar_imagem(&I);
	}
	| STRING IGUAL STRING MULTIPLICAR NUMERO
	{
		dbgmsg("Aplicando brilho de %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        dbgmsg("Li imagem %d por %d\n", I.width, I.height);
		aplicar_brilho($5, &I);
        salvar_imagem($1, &I);
		liberar_imagem(&I);
	}
	| STRING IGUAL STRING DIVIDIR NUMERO
	{
		dbgmsg("Aplicando brilho de %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        dbgmsg("Li imagem %d por %d\n", I.width, I.height);
		aplicar_brilho(1.0/$5, &I);
        salvar_imagem($1, &I);
		liberar_imagem(&I);
	}
	| ABRE_COL STRING FECHA_COL
	{
		imagem I = abrir_imagem($2);
        dbgmsg("Li imagem %d por %d\n", I.width, I.height);
		printf("%f\n", pixel_max(&I));
		liberar_imagem(&I);
	}				

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
	if (argc == 2) {
		if (strcmp("-d", argv[1]) == 0) {
			debug = 1;
		}
		else if (strcmp("--debug", argv[1]) == 0) {
			debug = 1;
		}
	}
	FreeImage_Initialise(0);
	yyparse();
	return 0;
}
