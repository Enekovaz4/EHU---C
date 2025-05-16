%option yylineno 
%option nounput

%{
 #include <string>
 using namespace std ;
 #include "Exp.hpp"
 #include "parser.hpp"


 #define TOKEN(t) return t
 #define TOKENAME(t) yylval.nombre = new std::string(yytext, yyleng) ; return t 

 extern int yyerror(const char *) ; 

%}


%%

#[^#\n]+                    ; // Comentario Linea
'''[^'#]*''' ;


program			TOKEN(RPROGRAM);
procedure		TOKEN(RPROCEDURE);
main			TOKEN(RMAIN);
def             TOKEN(RDEF);
let             TOKEN(RLET);
in              TOKEN(RIN);
id              TOKEN(RID);
int             TOKEN(RINT);
float           TOKEN(RFLOAT);
if              TOKEN(RIF);
forever         TOKEN(RFOREVER);
do              TOKEN(RDO);
until           TOKEN(RUNTIL);
else            TOKEN(RELSE);
break           TOKEN(RBREAK);
next            TOKEN(RNEXT);
print           TOKEN(RPRINT);
read            TOKEN(RREAD);





=               TOKEN(TASSIG);
\{              TOKEN(TLBRACE);
\}              TOKEN(TRBRACE);
\(              TOKEN(TLPARENTHESIS);
\)              TOKEN(TRPARENTHESIS);
#               TOKEN(THASHTAG);
\$              TOKEN(TDOLLAR);
\_              TOKEN(TUNDERSCORE);
:               TOKEN (TCOLON);
'               TOKEN (TAPOSTROPHE);
;               TOKEN (TSEMIC);
,               TOKEN (TCOMMA);
\+              TOKEN(TADD);
\-              TOKEN(TSUB);
\*              TOKEN(TMUL);
\/\/            TOKEN(TDIVENT);
\/              TOKEN(TDIVREAL);
&               TOKEN (TAMPERSAND);

==              TOKEN (TCEQ);
\/=             TOKEN (TCNE);
>=              TOKEN (TCGE);
\<=             TOKEN (TCLE);
\>               TOKEN (TCGT);
\<              TOKEN (TCLT);
\?              TOKEN (TQMARK);
\!              TOKEN (TEMARK);
\%              TOKEN (TPERCENT);
\"              TOKEN (TQUOTES);

[ \t\n]                 ;

[a-zA-Z][a-zA-Z0-9]*    TOKENAME(TID) ; 
[0-9]+\.[0-9]+          TOKENAME(TFLOAT_CNST); 
[0-9]+                  TOKENAME(TINT_CNST); 

.                       { yyerror("Unknown token");}
%%

