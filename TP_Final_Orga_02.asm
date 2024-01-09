.data
pregunta: .asciz "ingrese el mensaje, la clave y la opcion\n " //43
pregunta2: .asciz "comienzo de la etapa 2. ingrese un nuevo mensaje y una pista para decodificarlo.\n"

paridad: .asciz "la paridad es:   "//17

cantCambios: .asciz "la cantidad de caracteres procesados fue:     " //46 largo

input: .asciz "                                                                                " //80
nada2: .space 100

output: .asciz " "
nada4: .space 100

mensaje: .asciz " "
nada5: .space 100

clave: .asciz " "
nada6: .space 100

segundoMensaje: .asciz " "
nada11: .space 100

segundaPista: .asciz " "
nada13: .space 100

decodificacion: .asciz " "
nada14: .space 100

opcion: .asciz " "

desplazamiento: .asciz "                                                                                " //80
nada15: .space 100

saltoDeLinea: .asciz "\n"

abecedario: .ascii "abcdefghijklmnopqrstuvwxyz" //26 letras

.text

preguntar2:                             //el programa le pregunta al usuario el nuevo mensaje y la nueva clave
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#82
        ldr r1,=pregunta2
        swi 0
        bx lr
        .fnend

imprimirDesplazamiento:                 //se imprimir la cadena modificada.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#80
        ldr r1,=desplazamiento
        swi 0
        bx lr
        .fnend

imprimirDecodificacion:                 //se imprimir la cadena modificada.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,r6
        ldr r1,=decodificacion
        swi 0
        bx lr
        .fnend

preguntar:                              //el programa pregunta cual es el mensaje, clave y opcion.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#43
        ldr r1,=pregunta
        swi 0
        bx lr
        .fnend

ingresarTexto:                          //el programa "escucha" lo que va a decir el usuario.
        .fnstart
        mov r7,#3
        mov r0,#0
        mov r2,#80
        ldr r1,=input
        swi 0
        bx lr
        .fnend

imprimirSaltoDeLinea:                   //se imprimir la paridad del mensaje modificado.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#2
        ldr r1,=saltoDeLinea
        swi 0
        bx lr
        .fnend

imprimirCantidadDeCaracteresModificados:
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#46
        ldr r1,=cantCambios
        swi 0
        bx lr
        .fnend

imprimirMensajeModificado:              //se imprimir la cadena modificada.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,r6
        ldr r1,=output
        swi 0
        bx lr
        .fnend

imprimirParidad:                        //se imprimir la paridad del mensaje modificado.
        .fnstart
        mov r7,#4
        mov r0,#1
        mov r2,#17
        ldr r1,=paridad
        swi 0
        bx lr
        .fnend

///////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------ETAPA 1------------------//


iniciarExtraccion:
        push {lr}
        ldr r0,=input                   //donde voy a guardar el texto ingresado
        ldr r1,=mensaje                 //donde voy a guardar el mensaje extraido
        mov r4,#0                       //mi indice para recorrer el texto
        bl extraerMensaje               //extraigo el mensaje del texto


        mov r6,#0                       //indice para recorrer la clave
        ldr r2,=clave                   //donde voy a guardar la clave
        bl extraerClave                 //extraigo la clave del texto


        ldr r3,=opcion                  //donde voy a guardar la opcion
        bl extraerOpcion                //extraigo la opcion

        pop {lr}
        bx lr                           //me voy

extraerClave:
        ldrb r5,[r0,r4]                 //mi caracter
        cmp r5,#'A'                     //si tengo una letra
        bxge lr                         //me voy

        //agrego el caracter a la clave, ya sea ';' o numero

        strb r5,[r2,r6]                 //lo agrego
        add r4,#1                       //sumo mi indice
        add r6,#1                       //sumo mi indice
        b extraerClave                  //vuelvo al ciclo

extraerMensaje:
        ldrb r5, [r0, r4]               //mi caracter
        cmp r5, #';'                    //si tengo un ';'
        bxeq lr                         //salgo

        strb r5,[r1,r4]                 //guardo mi caracter
        add r4, #1                      //me muevo 1 byte
        b extraerMensaje                //vuelvo al ciclo

extraerOpcion:
        ldrb r5,[r0,r4]                 //mi caracter

        cmp r5,#'C'                     //si tengo la letra en masyucula
        bleq corregirOpcion             //la corrigo para que funcione

        cmp r5,#'D'                     //si tengo la letra en mayuscula
        bleq corregirOpcion             //la corrigo para que funcione

        strb r5,[r3]                    //guardo la letra
        bx lr                           //me voy

corregirOpcion:
        add r5,#0x20                    //paso la letra de la opcion a minuscula
        bx lr                           //vuelvo

///////////////////////////////////////////////////////////////////////////////////////////////////////////

minimizarTexto:
	push {lr}

        mov r4,#0                       //inicio mi indice
        bl buscarMayusculas             //busco las mayusculas

        pop {lr}
        bx lr                           //me voy

buscarMayusculas:
        ldrb r5,[r1,r4]                 //selecciono el caracter

        cmp r5,#00                      //si llegué al final
        bxeq lr                         //me voy

        cmp r5,#' '                     //lo comparo con un ' '
        beq ignorarEspacio              //lo ignoro

        cmp r5,#'Z'                     //lo comparo con 'Z'
        ble cambiarLetra                //si tengo una mayuscula, la cambio a minuscula

        add r4,#1                       //sumo mi indice
        b buscarMayusculas              //vuelvo al ciclo

cambiarLetra:
        add r5,#0x20                    //sumo 20 en hexadecimal para obtener el caracter en minuscula
        strb r5,[r1,r4]                 //intercambio la letra mayuscula por la letra minuscula
        add r4,#1                       //sumo mi indice
        b buscarMayusculas              //vuelvo al ciclo

ignorarEspacio:
        strb r5,[r1,r4]                 //guardo el espacio
        add r4,#1                       //sumo mi indice
        b buscarMayusculas              //vuelvo al ciclo

///////////////////////////////////////////////////////////////////////////////////////////////////////////

contarCaracteres:
        push {lr}

        mov r6,#0                       //inicializo el contador
        bl contarLargo                  //cuento el largo del mensaje extraido

	pop {lr}
        bx lr                           //me voy

contarLargo:
        ldrb r5,[r1,r6]                 //selecciono el elemento
        cmp r5,#00                      //si llego al final
        bxeq lr                         //me voy

        add r6,#1                       //aumento el contador
        b contarLargo                   //vuelvo al ciclo

///////////////////////////////////////////////////////////////////////////////////////////////////////////

modificar:
        push {lr}

        ldr r1,=mensaje                 //el mensaje que voy a codificar/decodificar
        ldr r2,=clave                   //la clave
        ldr r4,=output                  //donde voy a guardar el mensaje codificado/descodificado
        ldrb r3,[r3]                    //obtengo la opcion extraida
        ldr r11,=abecedario             //el abecedario

        mov r5,#0                       //indice para recorrer la clave
        mov r6,#0                       //indice para recorrer el texto

        b recorrerClave                 //voy al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

recorrerClave:
        ldrb r0,[r2,r5]                 //el caracter de la clave

        cmp r0,#';'                     //si tengo un ';'
        beq ignorar                     //lo ignoro

        cmp r0,#00                      //si llego al final
        beq reiniciarClave              //reinicio la clave

        bl calcularLongitudDelNumero    //calcula la congitud del numero de la clave
        bl pasar_a_entero               //paso a entero el valor de la clave

        b cambiar                       //hago la conversion de la letra

//////////////////////////////////////////////////////////////////////////////////////////////////////

pasar_a_entero:         //guarda el valor de la clave ya como entero en r8
        push {lr}
        mov r8,#0                       //el numero entero
        mov r9,#0                       //un contador
        mov r10,#10                     //el valor 10

ASCIIaEntero:
        cmp r9,r7                       //si contador == longitud
        beq salir                       //me voy

        ldrb r0,[r2,r5]                 //selecciono el caracter de la clave
        sub r0,#'0'                     //calculo el digito

        mul r8,r10                      //entero = entero * 10
        add r8,r0                       //entero + digito

        add r9,#1                       //sumo el contador
        add r5,#1                       //paso al siguiente caracter
        b ASCIIaEntero                  //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

calcularLongitudDelNumero:      //calcula la longitud del numero en r7
        push {lr}
        mov r7,#1                       //inicio mi contador
        mov r8,r5                       //copio el indice que recorre la clave
        add r8,#1                       //sumo el indice

longitudDeNumero:
        ldrb r9,[r2,r8]                 //el siguiente caracter de la clave

        cmp r9,#';'                     //si tengo un ';'
        beq salir                       //me voy

        add r7,#1                       //sumo el contador
        add r8,#1                       //sumo el indice

        b longitudDeNumero              //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

cambiar:
        ldrb r9,[r1,r6]                 //el caracter del mensaje

        cmp r9,#00                      //si llegué al final
        beq salir                       //me voy

        cmp r9,#' '                     //si tengo un expacio
        beq avanzar                     //avanzo

        cmp r3,#'c'                     //si tengo que codificar
        beq calcularCodificado          //lo codifico

        cmp r3,#'d'                     //si tengo que descifrar
        beq calcularDescifrado          //lo descifro

////////////////////////////////////////////////////////////////////////////////////////////////

calcularCodificado:
        mov r12,#0                      //indice para buscar la letra en el abecedario
        bl buscarPosicion

        add r12,r8                      //pos + desplazamiento
        bl calcularMod                  //calculo el resto

        bl guardarConversion            //codifico
        b recorrerClave                 //vuelvo a recorrer la clave

////////////////////////////////////////////////////////////////////////////////////////////////

guardarConversion:
        ldrb r9,[r11,r12]               //selecciono la letra en el abecedario
        strb r9,[r4,r6]                 //guardo el caracter codificado
        add r6,#1                       //sumo el indice que recorre el mensaje original
        bx lr                           //vuelvo

////////////////////////////////////////////////////////////////////////////////////////////////

calcularDescifrado:
        mov r12,#0                      //indice para buscar la letra en el abecedario
        bl buscarPosicion               //busco la posicion numerica de la letra cifrada en el abcedario

        sub r12,r8                      //pos - desplazamiento
        bl calcularMod                  //calculo el resto
        bllt arreglarSigno              //le arreglo el signo

        bl guardarConversion            //decodifico
        b recorrerClave                 //vuelvo al ciclo

////////////////////////////////////////////////////////////////////////////////////////////////

arreglarSigno:
        cmp r12,#0                      //si el resto es mayor a cero
        bxge lr                         //salgo

        add r12,#26                     //sumo el modulo, es decir 26
        b arreglarSigno                 //vuelvo al ciclo

calcularMod:                            //devuelve en r12 el resto
        cmp r12,#26                     //mientras el dividendo >= divisor (26)
        bxlt lr                         //vuelvo

        sub r12,#26                     //dividendo = dividendo - divisor
        b calcularMod

////////////////////////////////////////////////////////////////////////////////////////////////

buscarPosicion:                         //devuelve en r12 la posicion donde se encuentra el caracter
        ldrb r7,[r11,r12]               //elemento del abecedario

        cmp r7,r9                       //comparo los caracteres
        bxeq lr                         //si son iguales, salgo
        add r12,#1                      //sumo el indice del abecedario
        b buscarPosicion                //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

avanzar:
        strb r9,[r4,r6]                //guardo el espacio
        add r6,#1                      //sumo el indice que recorre el texto
        b recorrerClave                 //vuelvo al ciclo

reiniciarClave:
        mov r5,#0                       //lo vuelvo a inicializar en cero
        b recorrerClave                 //vuelvo a recorrer la clave

ignorar:
        add r5,#1                       //sumo el indice que recorre la clave
        b recorrerClave                 //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

calcularParidad:
        //r8: mi dividendo
        //r7: mi divisor
        //r6: mi resto

        mov r0,#16                      //para guardar la paridad en la posicion que quier
        mov r8,r6                       //guardo en r8 la cantidad de caracteres
        mov r7,#2                       //quiero saber si es divisible por 2
        mov r6,r8                       //el resto comienza siendo igual que el dividendo
        push {lr}
        bl calcularResto                //calculo el resto

        ldr r8,=paridad                 //donde voy a guardar la paridad original

        cmp r6,#0                       //si el resto es cero
        beq esPar                       //entonces es par

        mov r6,#'1'                     //guardo el caracter '1'
        strb r6,[r8,r0]

        pop {lr}
        bx lr                           //me voy

calcularResto:
        cmp r6,r7                       //si el resto es menor que el divisor
        bxlt lr                         //me voy

        sub r6,r6,r7                    //resto = resto - divisor
        b calcularResto                 //vuelvo al ciclo

esPar:
        mov r6,#'0'                     //guardo el caracter '0'
        strb r6,[r8,r0]                 //guardo el cero en la etiqueta
        pop {lr}
        bx lr                           //me voy

//////////////////////////////////////////////////////////////////////////////////////////////////////

convertirACodigoAscii:
        push {lr}

        mov r1,#10              //mi divisor
        mov r2,#0               //mi cociente
        ldr r4,=cantCambios     //donde voy a guardar los digitos
        mov r5,#45              //inicia en 46 para agregar los digitos de atras hacia adelante

        mov r9,r0               //guardo una copia de la cantidad de caracteres
        mov r10,#0              //una copia del cociente

        bl multiploDeDiez       //verifico si la cantidad es multiplo de diez
        cmp r9,#0               //si es cero, quiere decir que es multiplo
        bleq guardarCaracteres  //guardo el numero

        bl dividirNumero        //obtengo los digitos

        pop {lr}
        bx lr                   //vuelvo al main

//////////////////////////////////////////////////////////////////////////////////////////////////////

dividirNumero:
        cmp r0,#0               //si mi dividendo es 0
        beq salir              //no puedo dividirlo, me voy

        cmp r0,r1               //si el dividendo es menor que el divisor
        blt reiniciarDivision   //reinicio la division

        sub r0,r0,r1            //dividendo = dividendo - divisor
        add r2,r2,#1            //cociente = cociente + 1

        b dividirNumero         //vuelvo al ciclo

reiniciarDivision:
        bl guardarDigito        //guardo el digito
        bl cambiarDividendo     //cambio el dividendo

        mov r2,#0               //reinicio el cociente

        b dividirNumero         //vuelvo a dividir

guardarDigito:
        mov r3, r0              //resto = dividendo
        add r3,#0x30            //obtengo el numero como caracter
        strb r3,[r4,r5]         //guardo el caracter
        sub r5,#1               //resto el indice

        bx lr                   //vuelvo

cambiarDividendo:
        mov r0,r2               //intercambio el cociente con el dividendo
        bx lr                   //vuelvo

//////////////////////////////////////////////////////////////////////////////////////////////////////

multiploDeDiez:
        cmp r9,#0               //si mi dividendo es cero
        bxle lr                 //me voy

        sub r9,r9,r1            //dividendo = dividendo - divisor
        add r10,r10,#1          //cociente = cociente + 1

        b multiploDeDiez        //vuelvo al ciclo


guardarCaracteres:
        add r9,#0x30            //obtengo el ascii del cero
        add r10,#0x30           //obtengo el ascii del cociente

        strb r9,[r4,r5]         //guardo el cero
        sub r5,#1               //resto el indice
        strb r10,[r4,r5]        //guardo el cociente

        bx lr                   //me voy

//////////////////////////////////////////////////////////////////////////////////////////////////////


contarCaracteresModificados:
        push {lr}

        ldr r1,=mensaje                 //la direccion de memoria del mensaje original
        ldr r4,=output                  //la direccion de memoria del mensaje modificado

        mov r0,#0                       //un contador que almacena la cantidad de caracteres procesados
        mov r3,#0                       //un indice para recorrer ambas cadenas

        bl contar                       //cuento la cantidad de caracteres procesados

        pop {lr}
        bx lr                           //me voy


contar:
        ldrb r5,[r1,r3]                 //el caracter del mensaje original
        ldrb r6,[r4,r3]                 //el caracter del mensaje modificado

        cmp r5,#00                      //si llegué al final
        bxeq lr                         //me voy

        cmp r5,r6                       //comparo ambos caracteres
        bne sumar                       //si no son iguales, los sumo

        add r3,#1                       //sumo el indice para recorrer las cadenas
        b contar                        //vuelvo al ciclo

sumar:
        add r3,#1                       //sumo el indice para recorrer las cadenas
        add r0,#1                       //sumo el contador
        b contar                        //vuelvo al ciclo


//------------------------------ETAPA 2-------------------------------//

iniciarSegundaExtraccion:
        push {lr}

        ldr r0,=input                   //donde ingresé el texto
        ldr r1,=segundoMensaje          //donde voy a extraer el mensaje
        mov r4,#0                       //mi indice para recorrer el texto
        bl extraerSegundoMensaje        //extraigo el mensaje del segundo texto

        mov r6,#0
        add r4,#1
        ldr r2,=segundaPista
        bl extraerSegundaPista

        pop {lr}
        bx lr

extraerSegundaPista:
        ldrb r5,[r0,r4]                 //obtengo el caracter del a clave

        cmp r5,#'\n'                    //si llegué al final
        bxeq lr                         //me vuelvo

        cmp r5,#'Z'                     //si la letra es mayuscula
        ble letra_a_mayus               //pasala a minuscula

        strb r5,[r2,r6]                 //agrego el caracter a la pista

        add r4,#1                       //sumo el contador
        add r6,#1                       //sumo el indice
        b extraerSegundaPista           //vuelvo al ciclo

letra_a_mayus:
        add r5,#0x20
        bx lr

extraerSegundoMensaje:
        ldrb r5, [r0, r4]               //mi caracter

        cmp r5, #';'                    //si tengo un ';'
        bxeq lr                         //salgo

        strb r5,[r1,r4]                 //guardo mi caracter
        add r4, #1                      //me muevo 1 byte
        b extraerSegundoMensaje         //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

iniciarDecodificacion:
        push {lr}

        ldr r1,=segundoMensaje                  //el mensaje que voy a decodificar
        ldr r2,=segundaPista                    //la pista
        ldr r4,=decodificacion                  //donde voy a guardar el mensaje decodificado
        ldr r11,=abecedario                     //el abecedario

        mov r5,#0                               //indice para recorrer la pista
        mov r6,#0                               //indice para recorrer el mensaje

        b iniciarRecorrido                      //voy al ciclo

iniciarRecorrido:
        ldrb r0,[r2,r5]                         //el caracter de la pista
        ldrb r3,[r1,r6]                         //el caracter del mensaje

        cmp r0,#00                              //si llego al final
        beq reiniciarPista                      //reinicio la pista

        cmp r3,#00                              //si tengo null
        beq salir                               //me voy

        cmp r3,#' '                             //si tengo un espacio
        beq saltarEspacio                       //lo salteo

        cmp r0,#' '                             //si tengo un espacio
        beq saltearEspacio                      //lo ignoro

        bl distanciaConMensaje                  //calculo la distancia entre la pista y el mensaje

        b decodificar                           //decodifica el mensaje teniendo en cuenta la distancia

distanciaConMensaje:
        push {lr}

        mov r12,#0                              //indice para buscar la letra de la pista en el abecedario
        mov r9,r0                               //copio el caracter de la pista
        bl buscarPosicion                       //busco la posicion de la letra en el abecedario

        mov r10,r12                             //r10=la posicion de la letra de la pista

        mov r12,#0                              //indice para buscar la letra del mensaje en el abecedario
        mov r9,r3                               //copio el caracter del mensaje
        bl buscarPosicion                       //busco la posicion de la letra en el abecedario

        pop {lr}
        bx lr                                   //me voy

decodificar:
        //r10=mensaje  r12=pista

        cmp r10,r12                             //si los caracteres son identicos
        beq sonIdenticos                        //no los cambio

        sub r9,r12,r10                          //guardo la distancia entre los caracteres

	cmp r9,#0				//comparo la distancia con cero para saber si es negativa
	bllt distanciaNegativa			//si es negativa, lo paso a positivo

	sub r12,r9				//la posicion del caracter decodificado

        bl calcularMod                          //calculo el mod
        bl arreglarSigno                        //le arreglo el signo en caso de que sea negativo
        bl guardarConversion                    //guardo el caracter modificado

        add r5,#1                               //sumo el indice que recorre la pista

        b iniciarRecorrido                      //vuelvo al ciclo

sonIdenticos:
        bl guardarConversion                    //guardo el caracter sin ningun cambio
        add r5,#1                               //sumo el indice de la pista
        b iniciarRecorrido                      //vuelvo al ciclo

saltearEspacio:
        add r5,#1                               //sumo el indice que recorre la pista
        b iniciarRecorrido                      //vuelvo al ciclo

reiniciarPista:
        mov r5,#0                               //inicio el indice en cero
        b iniciarRecorrido                      //vuelvo al ciclo

saltarEspacio:
        strb r3,[r4,r6]                         //guardo el espacio
        add r6,#1                               //sumo el indice que recorre el mensaje

        b iniciarRecorrido                      //vuelvo al ciclo

distanciaNegativa:
        neg r9,r9
        bx lr

//////////////////////////////////////////////////////////////////////////////////////////////////////

crearDesplazamiento:
        push {lr}

        ldr r2,=segundaPista                    //el mensaje
        ldr r1,=segundoMensaje                  //la pista

        mov r4,#0                               //indice para recorrer el mensaje
        mov r5,#0                               //indice para recorrer la pista
        mov r6,#0                               //indice para agregar el desplazamiento

        b calcularDistancias                    //voy al ciclo

calcularDistancias:
        ldrb r0,[r2,r5]                         //el caracter de la pista
        ldrb r3,[r1,r4]                         //el caracter del mensaje

        cmp r3,#00                              //si llegué al final del mensaje
        beq salir                               //me voy

        cmp r0,#00                              //si llegué al final de la pista
        beq reiniciarPistaParaDesplazar         //reinicio la pista

        cmp r3,#' '                             //si tengo un espacio
        beq saltarEspacioParaDesplazar          //lo salteo

        cmp r0,#' '                             //si tengo un espacio
        beq saltearEspacioParaDesplazar         //lo ignoro

        ldr r11,=abecedario                     //el abecedario
        bl distanciaConMensaje                  //calculo la distancia entre la pista y el mensaje

        b colocarDesplazamiento                 //decodifica el mensaje teniendo en cuenta la distancia

colocarDesplazamiento:
        sub r9,r12,r10                          //guardo la distancia entre los caracteres

        cmp r9,#0                               //si la distancia es negativa
        bllt distanciaNegativa                  //la paso a positiva

        ldr r10,=desplazamiento                 //donde voy a guardar el desplazamiento
        mov r8,#';'                             //guardo el ';'
        strb r8,[r10,r6]                        //guardo el ';' en la etiqueta

        add r6,#1                               //sumo el indice del desplazamiento
        mov r7,#0                               //mi cociente es cero
        bl guardarDistancia                     //divido la distancia por 10 y guardo el cociente y el resto

        add r4,#1                               //sumo el indice del mensaje
        add r5,#1                               //sumo el indice de la pista

        b calcularDistancias                    //vuelvo al ciclo

//tengo el cociente en r7 y el resto en r9

guardarDistancia:
        cmp r9,#10                              //comparo la distancia con 10
        blt finDivision                         //si es menor a 10, termina la division

        sub r9,#10                              //dividendo - divisor
        add r7,#1                               //cociente++
        b guardarDistancia                      //vuelvo al ciclo

finDivision:
        add r7,#0x30                            //paso el cociente a ascii
        strb r7,[r10,r6]                        //guardo el cociente
        add r6,#1                               //sumo el indice del desplazamiento
        add r9,#0x30                            //paso el resto a ascii
        strb r9,[r10,r6]                        //guardo el resto
        add r6,#1                               //sumo el indice del desplazamiento
        add r4,#1                               //suma el indice del mensaje
        add r5,#1                               //suma el indice de la pista

        b calcularDistancias                    //vuelvo al ciclo

reiniciarPistaParaDesplazar:
        mov r5,#0                               //vuelve a iniciar en cero el indice de
        b calcularDistancias                    //vuelvo al ciclo

saltearEspacioParaDesplazar:
        add r5,#1                               //sumo el indice que recorre la pista
        b calcularDistancias                      //vuelvo al ciclo

saltarEspacioParaDesplazar:
	add r4,#1                               //sumo el indice que recorre el mensaje

        b calcularDistancias                      //vuelvo al ciclo

//////////////////////////////////////////////////////////////////////////////////////////////////////

salir:
        pop {lr}
        bx lr

fin:
        mov r7,#1
        swi 0

//////////////////////////////////////////////////////////////////////////////////////////////////////
.global main
main:
        bl preguntar                    	//el sistema consulta el texto
        bl ingresarTexto                	//el usuario ingresa el texto
        bl iniciarExtraccion            	//inicia el proceso de extraccion
        bl minimizarTexto               	//convierto el texto obtenido en minusculas


        bl modificar                    	//inicio el proceso de codificacion/decodificacion

                                        //preparativos para imprimir por pantalla

        bl contarCaracteres             	//cuento los caracteres de mi mensaje extraido
        bl imprimirMensajeModificado    	//se imprime por pantalla el mensaje modificado

        bl imprimirSaltoDeLinea         	//imprimo un salto de linea para separar las cosas

        bl calcularParidad              	//calculo la paridad del mensaje
        bl imprimirParidad              	//imprimo la paridad

        bl imprimirSaltoDeLinea			//imprimo un salto de linea

        bl contarCaracteresModificados  	//cuento la cantidad de caracteres modificados
        bl convertirACodigoAscii        	//convierto esa cantidad a ascii

        bl imprimirCantidadDeCaracteresModificados      //muestro esa cantidad por pantalla

        bl imprimirSaltoDeLinea         	//imprimo un salto de linea para separar las cosas

	bl preguntar2             		//el programa vuelve a preguntarle al usuario
        bl ingresarTexto  	                //el usuario vuelve a ingresar texto

	bl iniciarSegundaExtraccion             //inicia la segunda extraccion del mensaje

        bl minimizarTexto                       //pasa a minusculas el mensaje extraido

        bl iniciarDecodificacion                //inicia la decodificacion

        bl contarCaracteres                     //cuento la cantidad de caracteres a imprimir
        bl imprimirDecodificacion               //imprimo el mensaje decodificado

        bl imprimirSaltoDeLinea                 //imprimo un salto de linea

        bl crearDesplazamiento                  //creo el desplazamiento utilizado

        bl imprimirDesplazamiento               //imprimo el desplazamiento

        bl imprimirSaltoDeLinea                 ///imprimo un salto de linea

        bl fin                          	//termina el programa
