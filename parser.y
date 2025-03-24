%{
   #include <iostream>
   #include <string>
   using namespace std; 
   extern int yyerrornum;
   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
     yyerrornum++;
   }

%}

/* 
   Ikurrek zein atributu-mota duten 
      -------------------------------------
   
   Tipo de atributo de los símbolos
*/
%union {
    string *name ; 
}
/*****/

/* 
   Tokenak eta bere atributuak erazagutu. Honek tokens.l fitxategiarekin 
   bat etorri behar du.
   Lexikoak atributua duten tokenetarako memoria alokatzen du,
   hemen askatu behar da.
   

   ------------------------------------------------------------------------------
   
   Declarar tokens y sus atributos. Esta parte tiene que coincidir con el fichero
   tokens.l.
   El léxico reserva memoria para los tokens que tienen atributos,
   aquí hay que liberarla.
   
*/


%token RPROGRAM RPROCEDURE RMAIN RDEF RLET RIN RID RINT RFLOAT RFOREVER RIF RDO RUNTIL RELSE RBREAK RNEXT RPRINT RREAD
%token TLPARENTHESIS TRPARENTHESIS
%token TRBRACE TLBRACE TASSIG TSEMIC
%token THASHTAG TDOLLAR TUNDERSCORE
%token TADD TSUB TMUL TDIVENT TDIVREAL
%token TCOLON TAPOSTROPHE TCOMMA
%token TAMPERSAND
%token TCEQ TCNE TCGE TCLE TCGT TCLT
%token TQMARK TEMARK
%token TPERCENT

%token TQUOTES
%token <name> TID TFLOAT_CNST TINT_CNST

%nonassoc TCEQ TCNE TCGE TCLE TCGT TCLT

%left TADD TSUB

%left TMUL TDIVENT TDIVREAL


/* Hemen erazagutu atributuak dauzkaten ez-bukaerakoak 

-------------------------------------------------------

  Declarar aquí los no terminales que tienen atributos
 
*/

%type <name> statements statement expression


/*** Hemen definitu eragileen lehentasunak, maila bakoitzeko lerro bat:        */
/*** %left ezkerretik eskuinera ebaluatu                                       */
/*** %nonassoc bakarrik eragile bat onartzen da segidan                        */

/* ----------------------------------------------------------------------------*/

/*** Definir aquí las prioridades de los operadores, una línea por cada nivel: */
/*** %left evaluar de izquierda a derecha                                      */
/*** %nonassoc solo se admite un operador en la secuencia                      */

%%

start : RPROGRAM TID TLBRACE statements TRBRACE;
start : RDEF RMAIN TLPARENTHESIS TRPARENTHESIS mblock;

mblock: bl_decl TLBRACE subprogs statements TRBRACE;

block: bl_decl TLBRACE statements TRBRACE; 

bl_decl: RLET decl RIN 
        |;

decl:  decl TSEMIC id_list TCOLON type
        | id_list TCOLON type;

id_list: id_list TCOMMA TID
        | TID;

type: RINT
    |RFLOAT;

subprogs: subprogs subprog
        |;

subprog: RDEF TID arguments mblock;

arguments: TLPARENTHESIS par_list TRPARENTHESIS
        |;

par_list: id_list TCOLON par_class type par_list_r;

par_list_r: TSEMIC id_list TCOLON par_class type par_list_r
        |;

par_class: TAMPERSAND
        |;
      
statements: statements statement
        |;

statement: var_id_array TASSIG expression TSEMIC
        | RIF expression block
        | RFOREVER block
        | RDO block RUNTIL expression RELSE block
        | RBREAK RIF expression TSEMIC
        | RNEXT TSEMIC
        | RREAD TLPARENTHESIS var_id_array TRPARENTHESIS TSEMIC
        | RPRINT TLPARENTHESIS expression TRPARENTHESIS TSEMIC

var_id_array: TID

expression : expression TCEQ expression
        | expression TCGT expression
        | expression TCLT expression
        | expression TCGE expression
        | expression TCLE expression
        | expression TCNE expression
        | expression TADD expression
        | expression TSUB expression
        | expression TMUL expression
        | expression TDIVREAL expression
        | expression TDIVENT expression
        | expression  expression
        | TID
        | TINT_CNST
        | TFLOAT_CNST
        | TLPARENTHESIS expression TRPARENTHESIS
%%

