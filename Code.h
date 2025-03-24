#ifndef KODEA_H_
#define KODEA_H_
#include <iostream>
#include <sstream>
#include <fstream>
#include <set>
#include <vector>
#include <list>
#include "Aux.h"

/* Estructura para gestionar el código que se va a crear. En lugar de escribir el código directamente se guardará en 
 * esta estructura y, al final, se escribirá todo en un fichero.
 */
class Code {

private:

	/**************************/
	/* REPRESENTACIÓN INTERNA */
	/**************************/

	/* Instrucciones que componen el código. */
	std::vector<std::string> instrucciones;

	/* Clave para crear nuevos identificadores. Se incrementa cada vez que se crea un id nuevo. */
	int sigId;


public:

	/************************************/
	/* MÉTODOS PARA GESTIONAR EL CÓDIGO */
	/************************************/

	/* Constructor */
	Code();

	/* Crea un nuevo identificador del tipo "%t1, %t2, ..." y siempre diferente. */
	std::string nuevoId() ;

	/* Añade una nueva instrucción en la estructura. */
	void añadirInst(const std::string &stringInst);

	/* Dadas una lista de variables y su tipo, crear y añadir instrucciones de declaración */
	void añadirDeclaraciones(const IdLista &idNombres, const std::string &tipoNombre);

	/* Dados una lista de parámetros, el nombre del tipo y el tipo, crear y añadir instrucciones de declaración de parámetros */
	void añadirParametros(const IdLista &idNombres, const std::string &parTipoNombre, const std::string &tipoNombre) ;


	/* Les añade la referencia que les falta a las instrucciones declaradas.
	 * Por ejemplo: "goto" => "goto 20" */
	void completarInst(RefLista &numerosInst, const int valor);

	/* Escribe en el fichero las instrucciones acumuladas en la estructura. */
	void escribir();

	/* Devuelve el número de la siguiente instrucción. */
	int obtenref() const;


};

#endif /* CODE_H_ */
