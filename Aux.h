#ifndef AUX_H_
#define AUX_H_

#include <string>
#include <list>

typedef std::list<std::string> IdLista;
typedef std::list<int> RefLista;

struct adi {
  std::string nombre ;
  RefLista trueLista ;  // true palabra reservada en c
  RefLista falseLista ; // false palabra reservada en c
};



#endif /* AUX_H_ */
