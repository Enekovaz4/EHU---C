#ifndef STMT_HPP_
#define STMT_HPP_

#include <string>
#include <list>
   using namespace std; 

typedef list<string> IdLista;
typedef list<int> RefLista;


struct statementStruct {
  RefLista *breaks ;
  RefLista *next ;
  std::string nombre;
  RefLista trues ;
  RefLista falses ;

  // inicializar valores
  statementStruct() : 
    breaks(new RefLista()), 
    next(new RefLista()), 
    trues(), 
    falses() {} 
};

#endif /* STMT_HPP_ */
