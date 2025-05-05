#include "Codigo.hpp"

using namespace std;

/****************/
/* Constructora */
/****************/

Codigo::Codigo() {
  siguienteId = 1;
}

/***********/
/* nuevoId */
/***********/

string Codigo::nuevoId() {
  string nId("%T");
  nId += to_string(siguienteId++);
  return nId;
}

/*********************/
/* anadirInstruccion */
/*********************/

void Codigo::anadirInstruccion(const string &stringInst) {
  string instruccion;
  instruccion = to_string(obtenRef()) + ": " + stringInst;
  instrucciones.push_back(instruccion);
}


/***********************/
/* anadirDeclaraciones */
/***********************/

void Codigo::anadirDeclaraciones(const IdLista &idNombres, const string &tipoNombre) {
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion(tipoNombre + " " + *iter);
  }
}


/*********************/
/* anadirParametros  */
/*********************/

void Codigo::anadirParametros(const IdLista &idNombres, const string &parTipoNombre, const string &tipoNombre){ 
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion(parTipoNombre + "_" + tipoNombre + " " + *iter);
  }
}


/**************************/
/* completarInstrucciones */
/**************************/

void Codigo::completarInstrucciones(RefLista &numInstrucciones, const int valor) {
  string referencia = " " + to_string(valor) ;
  list<int>::iterator iter;
 
  for (iter = numInstrucciones.begin(); iter != numInstrucciones.end(); iter++) {
    instrucciones[*iter-1].append(referencia);
  }
}


/************/
/* escribir */
/************/

void Codigo::escribir() const {
  vector<string>::const_iterator iter;
  for (iter = instrucciones.begin(); iter != instrucciones.end(); iter++) {
    cout << *iter << endl;
  }
}


/************/
/* obtenRef */
/************/

int Codigo::obtenRef() const {
	return instrucciones.size() + 1;
}


/************/
/* Unir */
/************/

// list<int>* Codigo::unir(list<int> lis1, list<int> lis2)
// {
//    list<int>* nueva = new list<int>;
//    *nueva = lis1;
//    nueva->insert(nueva->end(), lis2.begin(), lis2.end());
//    return nueva;
// }

list<int> Codigo::unir(const list<int>& lis1, const list<int>& lis2)
{
    list<int> nueva = lis1;
    nueva.insert(nueva.end(), lis2.begin(), lis2.end());
    return nueva;
}


