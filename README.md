# Trabajo practico de assembler
## Producto final de la actividad. Al finalizar este trabajo tendremos un programa de consola escrito en lenguaje ensamblador ARM. Además tendremos una serie de procedimientos que nos permitirán implementar otros programas. 
### Propósito y sentido de la actividad. 


En este trabajo se van a desarrollar y poner en práctica los conceptos de arquitectura ARM que se ven durante la segunda parte de la materia después del primer parcial. En particular se presta atención a los siguientes conceptos:
- Datos almacenados en registros, pila, memoria
- Modos de direccionamiento
- Llamada a procedimientos del usuario e interrupciones del sistema


Estos puntos se ponen en práctica en el contexto de un juego de consola o terminal. Este contexto también permitirá implementar algunos conceptos vistos durante la primera parte de la materia, por ejemplo:
- Codificación de caracteres ASCII
- Conversión entre bases Decimal -> Binario, Binario -> Decimal
- Operaciones en Complemento A2

## Etapa 1
Se pide que el programa reciba un solo string con los datos:
- el mensaje
- la clave para codificar/decodificar
-  y una opción (c/d) que sirve para determinar si se codifica o se decodifica el mensaje 
usando la clave proporcionada.

*Gráficamente el input debe ser el siguiente string: “Mensaje; clave1;clave2;clave3;…; opción;”*

## Etapa 2
A partir de un mensaje cifrado, donde no conozco la clave, pero si tengo una pista. Se pide decodificarlo. 

Se debe ingresar un string, compuesto por el texto codificado y una palabra clave, de la misma cantidad de caracteres que el vector de desplazamiento, en base a esa palabra clave se determina el desplazamiento utilizado. 

Luego se decodifica el mensaje. Se debe mostrar por pantalla el mensaje decodificado y el desplazamiento usado

*Gráficamente el input debe ser el siguiente string:  “mensaje codificado + paridad” (nosotros solo aceptábamos el “mensaje codificado”).*
