%{
   #include <stdio.h>
   #include <iostream>
   #include <list>
   #include <string>
   #include <vector>
   using namespace std;

   extern int yyerrornum;
   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
     yyerrornum++;
   }

   #include "Codigo.hpp"
   #include "Exp.hpp"
   #include "Stmt.hpp"
   
   Codigo codigo;
%}

/*****/

/* 
   Tipo de atributo de los signos
   Recordar: un solo atributo por signo y deben tener tipos básicos (entero, real,
   carácter, puntero).                                  */

%union {
    string *nombre              ;
    IdLista *list               ;
    expressionStruct *expr      ;
    statementStruct *stmt      ;
    int ref                  ;
    RefLista *lent              ;
}

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

%token TQUOTES
%token <nombre> TADD TSUB TMUL TDIVENT TDIVREAL
%token <nombre> TASSIG 
%token <nombre> TID TFLOAT_CNST TINT_CNST
%token <nombre> RFLOAT RINT
%token <nombre> TCEQ TCNE TCGE TCLE TCGT TCLT

/*  Estos tokens no tienen atributos:   */

%token RPROGRAM RPROCEDURE RMAIN RDEF RLET RIN RID RFOREVER RIF RDO RUNTIL RELSE RBREAK RNEXT RPRINT RREAD
%token TLPARENTHESIS TRPARENTHESIS
%token TRBRACE TLBRACE TSEMIC
%token THASHTAG TDOLLAR TUNDERSCORE
%token TCOLON TAPOSTROPHE TCOMMA
%token TAMPERSAND
%token TQMARK TEMARK
%token TPERCENT


/* Hemen erazagutu atributuak dauzkaten ez-bukaerakoak 

-------------------------------------------------------

  Declarar aquí los no terminales que tienen atributos */
 
%type <expr> expression
%type <stmt> statement statements block
%type <nombre> type 
%type <list> var_id_array
%type <ref> M



/*** Hemen definitu eragileen lehentasunak, maila bakoitzeko lerro bat:        */
/*** %left ezkerretik eskuinera ebaluatu                                       */
/*** %nonassoc bakarrik eragile bat onartzen da segidan                        */

/* ----------------------------------------------------------------------------*/

/*** Definir aquí las prioridades de los operadores, una línea por cada nivel: */
/*** %left evaluar de izquierda a derecha                                      */
/*** %nonassoc solo se admite un operador en la secuencia                      */
%nonassoc TCEQ TCNE TCGE TCLE TCGT TCLT

%left TADD TSUB
%left TMUL TDIVENT TDIVREAL


/*Símbolo de comienzo*/
%start start

%%







start : RPROGRAM TID TLBRACE statements TRBRACE;
start : RDEF RMAIN TLPARENTHESIS TRPARENTHESIS { codigo.anadirInstruccion("prog main");}  mblock;

mblock: bl_decl TLBRACE subprogs statements TRBRACE { 
                codigo.anadirInstruccion("goto ");
        } ;

block: TLBRACE statements TRBRACE {
                $$->breaks = $2->breaks;
                $$->next = $2->next;
        }; 
        

bl_decl: RLET decl RIN 
        |%empty;

decl:  decl TSEMIC id_list TCOLON type
        | id_list TCOLON type;

id_list: id_list TCOMMA TID
        | TID;

type: RINT
    |RFLOAT;

subprogs: subprogs subprog
        |%empty;

subprog: RDEF TID arguments mblock;

arguments: TLPARENTHESIS par_list TRPARENTHESIS
        |%empty;

par_list: id_list TCOLON par_class type par_list_r;

par_list_r: TSEMIC id_list TCOLON par_class type par_list_r
        |%empty;

par_class: TAMPERSAND
        |%empty;
      
statements : statements statement 
        {
                $$ = new statementStruct;
                $$->breaks = codigo.unir($1->breaks, $2->breaks);
                $$->next = codigo.unir($1->next, $2->next);
        }
           |%empty
        {
                $$->breaks = new list<int>();
                $$->next = new list<int>();
        } ;

statement : var_id_array TASSIG expression TSEMIC { // TODO Corregir
                $$ = new statementStruct;
                
                codigo.anadirInstruccion(($1->front()) + " := " + $3->nombre);

                $$->breaks = new RefLista();
                $$->next = new RefLista();
        }

          | RIF expression M block M {
                $$ = new statementStruct;

                codigo.completarInstrucciones($2->trues, $3);
                codigo.completarInstrucciones($2->falses, $5);

                $$->next = $4->next;
                $$->breaks = $4->breaks;
          }
          | RFOREVER M block{
                $$ = new statementStruct;

                codigo.anadirInstruccion("goto " + to_string($2));

                codigo.completarInstrucciones(*($3->breaks), codigo.obtenRef());
                codigo.completarInstrucciones(*($3->next), $2);

                $$->next = new RefLista();
                $$->breaks = new RefLista();
          }
          | RDO M block RUNTIL expression RELSE M block M {
                $$ = new statementStruct;

                codigo.completarInstrucciones($5->trues, $9);
                codigo.completarInstrucciones($5->falses, $2);

                codigo.completarInstrucciones($3->breaks, $7);
                codigo.completarInstrucciones($3->next, $7);

                $$->next = new RefLista;
                $$->breaks = new RefLista;
          }
          | RBREAK RIF expression TSEMIC {
                $$ = new statementStruct;
               
                codigo.completarInstrucciones($3->trues, codigo.obtenRef());

                $$->breaks = new RefLista();
                $$->breaks->push_back(codigo.obtenRef());
                $$->next = new RefLista();
          }
          | RNEXT TSEMIC {
                $$ = new statementStruct;

                codigo.anadirInstruccion("goto ");

                $$->next = new RefLista();
                $$->next->push_back(codigo.obtenRef());
                $$->breaks = new RefLista();
          }
          | RREAD TLPARENTHESIS var_id_array TRPARENTHESIS TSEMIC {
                $$ = new statementStruct;

                $$->breaks = new RefLista();
                $$->next = new RefLista();

                for (const std::string& varName : *$3) {
                        codigo.anadirInstruccion("read " + varName);
                }
          }
          | RPRINT TLPARENTHESIS expression TRPARENTHESIS TSEMIC {
                $$ = new statementStruct;

                codigo.anadirInstruccion("write " + $3->nombre);

                $$->breaks = new list<int>();
                $$->next = new list<int>();
          }

var_id_array: TID{
    $$ = new std::list<std::string>;
    $$->push_back(*$1);
};

expression : expression TCEQ expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TCGT expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TCLT expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TCGE expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TCLE expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TCNE expression{ 
                $$ = new expressionStruct;
                $$->trues.push_back(codigo.obtenRef()) ;
                $$->falses.push_back(codigo.obtenRef()+1) ;
                codigo.anadirInstruccion("if " + $1->nombre + " " + *$2 + " " + $3->nombre  + " goto") ;
                codigo.anadirInstruccion("goto") ;
             }
        | expression TADD expression{ 
                        $$ = new expressionStruct;
                        $$->nombre = codigo.nuevoId();
                        $$->falses = list<int>();
                        $$->trues = list<int>();
                        codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " + " + $3->nombre) ;
             }
        | expression TSUB expression{ 
                        $$ = new expressionStruct;
                        $$->nombre = codigo.nuevoId();
                        $$->falses = list<int>();
                        $$->trues = list<int>();
                        codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " - " + $3->nombre) ;
             }
        | expression TMUL expression{ 
                        $$ = new expressionStruct;
                        $$->nombre = codigo.nuevoId();
                        $$->falses = list<int>();
                        $$->trues = list<int>();
                        codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " * " + $3->nombre) ;
             }
        | expression TDIVREAL expression{ 
                        $$ = new expressionStruct;
                        $$->nombre = codigo.nuevoId();
                        $$->falses = list<int>();
                        $$->trues = list<int>();
                        codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " / " + $3->nombre) ;
             }
        | expression TDIVENT expression{ 
                        $$ = new expressionStruct;
                        $$->nombre = codigo.nuevoId();
                        $$->falses = list<int>();
                        $$->trues = list<int>();
                        codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " div " + $3->nombre) ;
             }
        | TID{
                $$ = new expressionStruct;
                $$->nombre = *$1;
                $$->falses = list<int>();
                $$->trues = list<int>();
             }
        | TINT_CNST{
                $$ = new expressionStruct;
                $$->nombre = *$1;
                $$->falses = list<int>();
                $$->trues = list<int>();
             }
        | TFLOAT_CNST{
                $$ = new expressionStruct;
                $$->nombre = *$1;
                $$->falses = list<int>();
                $$->trues = list<int>();
             }
        | TLPARENTHESIS expression TRPARENTHESIS{
                $$ = new expressionStruct;
                $$->nombre = $2->nombre;
                $$->falses = $2->falses;
                $$->trues = $2->trues;
             }
M:  %empty { $$ = codigo.obtenRef() ; }
%%

