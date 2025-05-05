#ifndef EXP_HPP_
#define EXP_HPP_

#include <string>
#include <list>
   using namespace std; 

typedef list<string> IdLista;
typedef list<int> RefLista;


struct expressionStruct {
  std::string nombre;
  RefLista trues ;
  RefLista falses ;
};

struct statementStruct {
  RefLista breaks ;
  RefLista next ;
};

#endif /* EXP_HPP_ */
