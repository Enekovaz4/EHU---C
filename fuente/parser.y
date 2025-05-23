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
    statementStruct *stmt       ;
    int ref                     ;
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
%token <nombre> TCEQ TCNE TCGE TCLE TCGT TCLT ROR RAND RNOT

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
%type <nombre> type par_class var_id_array
%type <list> id_list
%type <ref> M



/*** Hemen definitu eragileen lehentasunak, maila bakoitzeko lerro bat:        */
/*** %left ezkerretik eskuinera ebaluatu                                       */
/*** %nonassoc bakarrik eragile bat onartzen da segidan                        */

/* ----------------------------------------------------------------------------*/

/*** Definir aquí las prioridades de los operadores, una línea por cada nivel: */
/*** %left evaluar de izquierda a derecha                                      */
/*** %nonassoc solo se admite un operador en la secuencia                      */
%nonassoc TCEQ TCNE TCGE TCLE TCGT TCLT ROR RAND RNOT

%left TADD TSUB
%left TMUL TDIVENT TDIVREAL


/*Símbolo de comienzo*/
%start start

%%







/*start : RPROGRAM TID TLBRACE statements TRBRACE;*/
start : RDEF RMAIN TLPARENTHESIS TRPARENTHESIS { codigo.anadirInstruccion("prog main");}  mblock;

mblock: bl_decl TLBRACE subprogs statements TRBRACE { 
                codigo.anadirInstruccion("goto ");
        };

block: TLBRACE statements TRBRACE {
                $$ = new statementStruct;

                $$->breaks = $2->breaks;
                $$->next = $2->next;
        };
        

bl_decl: RLET decl RIN 
        |%empty;

decl:  decl TSEMIC id_list TCOLON type {
        codigo.anadirDeclaraciones(*$3, *$5);
}
        | id_list TCOLON type {
                codigo.anadirDeclaraciones(*$1, *$3);
        };

id_list: id_list TCOMMA TID {
        $$ = $1;
        $$->push_back(*$3);
}
        | TID {
                $$ = new IdLista();
                $$->push_back(*$1);
        };

type: RINT { $$ = new std::string("int"); }
    |RFLOAT { $$ = new std::string("real"); };

subprogs: subprogs subprog
        |%empty;

subprog: RDEF TID { codigo.anadirInstruccion("prog " + *$2); } arguments mblock;

arguments: TLPARENTHESIS par_list TRPARENTHESIS
        |%empty;

par_list: id_list TCOLON par_class type {
    codigo.anadirParametros(*$1, *$3, *$4);
} par_list_r

par_list_r: TSEMIC id_list TCOLON par_class type {
    codigo.anadirParametros(*$2, *$4, *$5);
} par_list_r
        |%empty;

par_class: TAMPERSAND { $$ = new std::string("ref"); }
        |%empty { $$ = new std::string("val"); }; 
      
statements : statements statement 
        {
                $$ = new statementStruct;

                $$->breaks = codigo.unir($1->breaks, $2->breaks);
                $$->next = codigo.unir($1->next, $2->next);
        }
           |%empty
        {
                $$ = new statementStruct;
        };

statement : var_id_array TASSIG expression TSEMIC {
                $$ = new statementStruct;
                
                codigo.anadirInstruccion(*$1 + " := " + $3->nombre);
        };
          | RIF expression M block M {
                $$ = new statementStruct;

                codigo.completarInstrucciones($2->trues, $3);
                codigo.completarInstrucciones($2->falses, $5);

                $$->next = $4->next;
                $$->breaks = $4->breaks;
          };
          | RFOREVER M block {
                $$ = new statementStruct;

                codigo.anadirInstruccion("goto " + to_string($2));

                codigo.completarInstrucciones($3->breaks, codigo.obtenRef());
                $$->next = $3->next; // TODO Esta bien DONE

          };
          | RDO M block RUNTIL expression RELSE M block M {
                $$ = new statementStruct;

                codigo.completarInstrucciones($5->trues, $9);
                codigo.completarInstrucciones($5->falses, $2);

                codigo.completarInstrucciones($3->breaks, $9); // TODO corregir en ETDS DONE
                codigo.completarInstrucciones($3->next, $7);
          };
          | RBREAK RIF expression TSEMIC {
                $$ = new statementStruct;
               
                codigo.completarInstrucciones($3->falses, codigo.obtenRef());

                $$->breaks = $3->trues;
          };
          | RNEXT TSEMIC {
                $$ = new statementStruct;

                $$->next.push_back(codigo.obtenRef());

                codigo.anadirInstruccion("goto ");

          }
          | RREAD TLPARENTHESIS var_id_array TRPARENTHESIS TSEMIC {
                $$ = new statementStruct;

                codigo.anadirInstruccion("read " + *$3);
          };
          | RPRINT TLPARENTHESIS expression TRPARENTHESIS TSEMIC {
                $$ = new statementStruct;

                codigo.anadirInstruccion("write " + $3->nombre);
          };
          | TID arguments TSEMIC {
                $$ = new statementStruct;

                codigo.anadirInstruccion("call " + *$1);
          };

var_id_array: TID{
    $$ = $1;
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
                codigo.anadirInstruccion("if " + $1->nombre + " < " + $3->nombre  + " goto") ;
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
        | expression ROR M expression {
                $$ = new expressionStruct;
                codigo.completarInstrucciones($1->falses, $3);
                $$->trues = codigo.unir($1->trues, $4->trues);
                $$->falses = $4->falses;
        }
        | expression RAND M expression {
                $$ = new expressionStruct;
                codigo.completarInstrucciones($1->trues, $3);
                $$->trues = $4->trues;
                $$->falses = codigo.unir($1->falses, $4->falses);
        }
        | RNOT expression {
                $$ = new expressionStruct;
                $$->falses = $2->trues;
                $$->trues = $2->falses;
        }
M:  %empty { $$ = codigo.obtenRef() ; }
%%

