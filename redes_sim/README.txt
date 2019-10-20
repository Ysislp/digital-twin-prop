Se adjunta:

modeltest.m : Archivo matlab para el test de métodos que se ajustaran más a las mediciones.

TestWorkspace : workspace del modeltest.m con los datos iniciales (se carga automáticamente).

main.m : Archivo donde se simula la unión de la dosis de coagulante (cada hora por las mediciones en la planta),
         con los sedimentadores de Epanet (se toman los datos cada segundo).
	 La simulación se presenta en horas y corre durante 1 día.

coagulantFunc.m : Función que calcula la dosis de coagulante.

Net00-new: Archivo Epanet, que representa la estructura de 2 sedimentadores, con la
	   relación de medidas de la planta real. Los caudales se operan desde Matlab.
	   De igual forma el archivo es cargado automáticamente.

El Toolkit de Epanet debe estar cargado para realizar la simulación, o estar en la misma carpeta.