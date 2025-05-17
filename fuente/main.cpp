#include <iostream>
extern int yyparse();
using namespace std;

int yyerrornum = 0;

int main(int argc, char **argv)
{
  if (yyparse() == 0 && yyerrornum == 0) {
    cout << endl << "\tHa acabado BIEN..." << endl ;
  }
  else {
    cout << endl<< "\tHa acabado MAL." << endl << "Número de errores: " << yyerrornum << endl ;
  }
  return 0;
}
