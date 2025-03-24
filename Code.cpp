#include "Code.h"

using namespace std;


/*****************/
/* Constructor   */
/*****************/

Code::Code() {
  sigId = 1;
}


/************/
/* nuevoId  */
/************/

string Code::nuevoId() {
    string nuId("%t");
    nuId += to_string(sigId++);
    return nuId;
}


/****************/
/* añadirInst  */
/****************/

void Code::añadirInst(const string &stringInst) {
  string instruccion;
  instruccion = to_string(obtenref()) + ": " + stringInst;
  instrucciones.push_back(instruccion);
}

/**********************/
/* añadirDeclaraciones */
/**********************/

void Code::añadirDeclaraciones(const IdLista &idNombres, const string &tipoNombre) {
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    añadirInst(tipoNombre + " " + *iter);
  }
}

/**********************/
/* añadirParametros   */
/**********************/

void Code::añadirParametros(const IdLista &idNombres, const string &parTipoNombre, const string &tipoNombre){ 
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    añadirInst(parTipoNombre + "_" + tipoNombre + " " + *iter);
  }
}

/*****************/
/* completarInst */
/*****************/

void Code::completarInst(RefLista &numerosInst, const int valor) {
  string ref = " " + to_string(valor);
  RefLista::iterator iter;
  for (iter = numerosInst.begin(); iter != numerosInst.end(); iter++) {
    instrucciones[*iter-1].append(ref);
  }
}


/************/
/* escribir */
/************/

void Code::escribir() {
  vector<string>::const_iterator iter;
  for (iter = instrucciones.begin(); iter != instrucciones.end(); iter++) {
    cout << *iter << endl;
  }
}


/**************/
/* obtenref */
/**************/

int Code::obtenref() const {
    return instrucciones.size() + 1;
}


