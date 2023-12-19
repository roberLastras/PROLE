/*
 *	Titulo: Practica 1 de Flex
 *	Autores: Alberto Santos y Roberto Lastras
 *	Grupo: 103
 */

	int contCOM = 0;
	int contElemtVacios = 0;
	int contAtributos = 0;
	int atributos = 0;
	int tamano = 0;
	int tamanoFinal = 0;
	char etiqueta[100];
	char etiquetaFinal[100];
	char prefijo[100];
	char prefijoFinal[100];
	char nombre[100];
	char nombreFinal[100];
NAME	[a-z0-9]*

%x CDATA COM STAG ATTR PREF NOM

%%

"<"				{BEGIN(STAG);						/*Cuando encuentra el caracter "<" cambia a la condicion de arranque "STAG"*/}
<STAG>{NAME}			{BEGIN(ATTR); strcpy(etiqueta, yytext);			/*Si despues de "<" encuentra una cadena compuesta de letras minusculas y numeros, cambia a la condicion de arranque "ATTR" y guarda la cadena ya que es el nombre de la etiqueta*/}
<STAG>"![CDATA["		{BEGIN(CDATA); 						/*Si despues de "<" encuentra la siguiente cadena: "![CDATA[", cambia a la condicion de arranque "CDATA"*/}
<STAG>"!--"			{BEGIN(COM);						/*Si despues de "<" encuentra la siguiente cadena: "!--", cambia a la condicion de arranque "COM"*/}

<ATTR>" "{NAME}"="		{contAtributos++;					/*Dentro del estado "ATTR" cada vez que encuenta una cadena compuesta de letras minusculas y numeros entre un espacio(" ") y un igual("="), aumenta + 1 el contador de atributos*/}
<ATTR>"xmlns"":"		{BEGIN(PREF);						/*Dentro del estado "ATTR" cada vez que encuenta "xmlns"":", cambia a la condicion de arranque "PREF"*/}

<PREF>{NAME}			{strcpy(prefijo, yytext); 				/*Dentro del estado "PREF" cada vez que encuenta una cadena compuesta de letras minusculas y numeros, la guarda ya que es el nombre del prefijo*/}
<PREF>"="			{BEGIN(NOM);						/*Dentro del estado "PREF" cada vez que encuenta "=", cambia a la condicion de arranque "NOM"*/}

<NOM>"\""[^\"]*			{strcpy(nombre, yytext); tamano = yyleng-1; BEGIN(ATTR);/*Dentro del estado "NOM" cada vez que encuenta unas comillas("\"") seguido de una cadena de cualquier tipo de caracteres excepto comillas([^\"]*), guarda la cadena ya que es el nombre del espacio de nombres, guarda el tamaño de la cadena - 1 para restar la primera comilla y cambia a la condicion de arranque "ATTR" */}

<ATTR>("/>"|"></")		{contElemtVacios++; BEGIN(INITIAL);			/*Dentro del estado "ATTR" cada vez que encuenta "/>" o "></", aumenta + 1 el contador de elementos vacios y cambia a la condicion de arranque "INITIAL"*/}
<ATTR>">"			{BEGIN(INITIAL);					/*Dentro del estado "ATTR" cada vez que encuenta ">", cambia a la condicion de arranque "INITIAL"*/}
 
<COM>"-->"			{contCOM++; BEGIN(INITIAL);				/*Dentro del estado "COM" cada vez que encuenta "-->", aumenta + 1 el contador de comentarios y cambia a la condicion de arranque "INITIAL"*/}

<CDATA>. 			{;							/*Dentro del estado "CDATA" ignora todo el contenido*/}
<CDATA>"]]>"			{BEGIN(INITIAL);					/*Dentro del estado "CDATA" cada vez que encuenta "]]>", cambia a la condicion de arranque "INITIAL"*/}

\n				{							/*Cada vez que encuentre un salto de linea realiza las siguientes operaciones*/
					if(contAtributos>=atributos){ 			/*Compara el numero de atributos que hay en cada etiqueta y se queda con el numero maximo de atributos y la etiqueta de esos atributos*/
						atributos = contAtributos; 
						strcpy(etiquetaFinal, etiqueta);
					}	
					contAtributos = 0;
					if(tamano>tamanoFinal){				/*Compara el tamaño de caracteres de los espacio de nombres y se queda con tamaño mas grande y su respectivo nombre y prefijo*/
						tamanoFinal = tamano;	
						strcpy(nombreFinal, nombre);
						strcpy(prefijoFinal, prefijo);
					}
					tamano = 0;			
				}		

%%

int main (){

	yylex();
	
	//Muestra por pantalla los resultados
	printf("\nNumero de comentarios: %d\n", contCOM);
	printf("Numero de elementos vacios: %d\n", contElemtVacios);
	printf("La etiqueta \"%s\" es la que más atributos tiene en su interior: %d.\n", etiquetaFinal, atributos);
	printf("El valor más largo de espacio de nombres es %s\" (%d caracteres) y el prefijo asociado es \"%s\".\n", nombreFinal, tamanoFinal, prefijoFinal);
	
	return 0;

}
