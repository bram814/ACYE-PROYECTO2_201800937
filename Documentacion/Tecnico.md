# [Manual Técnico](../README.md)



___
### Índice
1. [Requerimientos](#reque)
2. [Instalar Requerimientos](#instalarReque)
2. [Especificaciones del Sistema](#especifa)
3. [Clases que Conforman la Estructura del Proyecto](#estrucProye)
4. [Métodos de Macros](#mMacros)
4. [Métdos de File](#exprTec)
4. [Main](#main)

____
### Requerimientos <a name="reque"></a>
-   Contar con la herramienta DOSBox version 0.74-3
-   Tener Microsoft Macro Assembler (**MASM**) es un ensamblador para la familia x86 de microprocesadores.
-   Algún editor de código para Masm, de preferencia **Sublime Text**

___
### Instalando requerimientos <a name="instalarReque"></a>

Para instalar **dosbox** en Ubuntu ejecutar los siguientes comandos:
```bash
sudo apt-get update
sudo apt-get install dosbox
```
_______

### Especificaciones del sistema <a name="especifa"></a>

El sistema fue desarrollado en **Masm**, por medio de una interfaz dosbox, está conformado por la clase main (principal), file y macros.

________

### Clases que conforman la estructura del proyecto <a name="estrucProye"></a>

-   **Main.asm**
Esta clase tendrá todos los segmentos, como de liberías, stack, datos y codigo.

-   **Macros.asm**
Está clase está conformado por todos los macros utilizados en el proyecto.

-   **File.asm**
Está clase está conformada por métodos en cargados de lectura, escritura, creación y cerrado de archivos.

_____
### Métodos de Macros <a name="mMacros"></a>

El macro GetPrint es el encargo de imprimir una variable.

```java
; ************** [IMPRIMIR] **************
GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm
```

Son los métodos en cargados de obtener la entrada por teclado.
```java
; ************** [CAPTURAR ENTRADA] **************
GetInput macro 
	MOV AH,01H ; 1 char
	int 21H
endm

GetInputMax macro cadena
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 20 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[cadena]
	int 21h
endm
```

Estos métodos son los encargados de conertir un strin a int, y viceversa.
```java


;convierte un NUMERO a CADENA que esta guardado en AX 
Int_String macro intNum
  local div10, signoN, unDigito, obtenerDePila
  ;Realizando backup de los registros BX, CX, SI
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
  xor cx,cx
  xor bx,bx
  xor dx,dx
  mov bx,0ah 				; Divisor: 10
  test ax,1000000000000000 	; veritficar si es numero negativo (16 bits)
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h 	; Se agrega un CERO para que sea un numero de dos digitos
      inc si
      jmp div10
  signoN:					; Cambiar de Signo el numero 
  	  neg ax 				; Se niega el numero para que sea positivo
  	  mov intNum[si], 2dh 	; Se agrega el signo negativo a la cadena de salida
  	  inc si
  	  jmp unDigito
  div10:
      xor dx, dx 			; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx 				; Se divide entre 10
      inc cx 				; Se incrementa el contador
      push dx 				; Se guarda el residuo DX
      cmp ax,0h 			; Si el cociente es CERO
      je obtenerDePila
	  jmp div10
  obtenerDePila:
      pop dx 				; Obtenemos el top de la pila
      add dl,30h 			; Se le suma '0' en su valor ascii para numero real
      mov intNum[si],dl 	; Metemos el numero al buffer de salida
      inc si
      loop obtenerDePila
      mov ah, '$' 			; Se agrega el fin de cadena
      mov intNum[si],ah
      						; Restaurando registros
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm

;convierte una CADENA A NUMERO, este es guardado en AX.
String_Int macro stringNum
  local ciclo, salida, verificarNegativo, negacionRes
  push bx
  push cx
  push dx
  push si
  ;Limpiando los registros AX, BX, CX, SI
  xor ax, ax
  xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah						;multiplicador 10
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh 					; compara para ignorar el "-"
      jz ciclo    					; Se ignora el simbolo '-' de la cadena
      cmp cl, 30h 					; Si el caracter es menor a '0', implica que es negativo (verificacion)
      jb verificarNegativo 			; ir para cuando es un negativo 
      cmp cl, 39h 					; Si el caracter es mayor a '9', implica que es negativo (verificacion)
      ja verificarNegativo
  	  sub cl, 30h					; Se le resta el ascii '0' para obtener el número real
  	  mul bx      					; multplicar ax
      mov ch, 00h
   	  add ax, cx  					; sumar para obtener el numero total
  	  jmp ciclo
  negacionRes:
      neg ax 						; negacion por si es negativo el resultado
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh 		; Si existe un signo al inicio del numero, negamos el numero
      jz negacionRes
  salida:
      								; Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
endm


```


Vector donde se muestra el carro
```java

xcarro0         dw  0 ; pos x
ycarro0         dw  0 ; pos y
carro0Fila1     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
carro0Fila2     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
carro0Fila3     db  00, 00, 00, 00, 39, 39, 39, 00, 00, 00, 00
carro0Fila4     db  00, 00, 00, 00, 39, 39, 39, 00, 00, 00, 00
carro0Fila5     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
carro0Fila6     db  00, 00, 15, 15, 14, 14, 14, 15, 15, 00, 00

```


Macro para dibujar el carro inicial.
```java
dibujarnave macro
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    auxdiblinea naveFila1, 11
    add ax, 320
    auxdiblinea naveFila2, 11
    add ax, 320
    auxdiblinea naveFila3, 11
    add ax, 320
    auxdiblinea naveFila4, 11
    add ax, 320
    auxdiblinea naveFila5, 11
    add ax, 320
    auxdiblinea naveFila6, 11
endm

```

Además se agrego un macro donde podemos agregar por medio de parametros varias filas. Sirve más que todo para lso carros que están bajando.

```java
dibujarCarroN macro f1, f2, f3, f4, f5, f6
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    auxdiblinea f1, 11
    add ax, 320
    auxdiblinea f2, 11
    add ax, 320
    auxdiblinea f3, 11
    add ax, 320
    auxdiblinea f4, 11
    add ax, 320
    auxdiblinea f5, 11
    add ax, 320
    auxdiblinea f6, 11
endm
```

Macro para poder imprimir en la pantalla del modo de vide, donde el primer parametro, es la variable que queremos mostrar como texto, el siguiene parametro indica la columan que va estar almacenado en dl, mientras que el tercer parametro  es la fialque va a estar almacenado en dh.

```java

imprimirPantalla macro buffer, columna, fila
    local e1, e2
    mov dl, columna
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, fila
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset buffer
        mov ah, 09h
        int 21h
    e2:
endm


```


macro para imprimir el tiempo en el modo de video.

```java
imprimirtiempo macro
    local e1
    mov al, minutos
    aam
    mov decminutos, ah
    mov uniminutos, al
    mov al, segundos
    aam
    mov decsegundos, ah
    mov unisegundos, al
    
    mov dl, 35
    e1:
        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add decminutos, '0'
        mov al, decminutos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add uniminutos, '0'
        mov al, uniminutos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        mov al, 58
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add decsegundos, '0'
        mov al, decsegundos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add unisegundos, '0'
        mov al, unisegundos
        mov bl, 1fh
        mov cx, 1
        int 10h
endm
```


Inicio del macro GetPlay, iniciamos con el modo de video, por consiguiente, podemos inicializar la posición del carro por medio de su eje 'x' y 'y'. Además, también se inicializa el tiempo, punteo y vidas.
```java
xor si, si
    ;entra en modo grafico
    ;ah = 0
    ;al = 13h
    ;Resolucion 320x200 con 256 colores
    mov ax, 13h
    int 10h
    ;offset de la memoria de video importante
    mov ax, 0A000h
    mov es, ax
    ;coordenadas donde empezara a dibujar el carro
    mov xnave, 150
    mov ynave, 185
    ; coordenadas donde empezara a dibujar el carroN
    ; carro 0
    mov xcarro0, 52
    mov ycarro0, 23
    ; carro 1

    ; vidas
    mov vidas, 3
    ; puntos 
    mov _PUNTEOI, 0
    ;set tiempo en 0
    mov segundos, 0
    mov minutos, 0
    mov micsegundos, 0
    mov inicialTime, 0

```



### Métodos de File <a name="exprTec"></a>

Es el encargado de obtener la ruta a leer.
```java
; ************** [PATH][GET] **************
GetRoot macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,00H ; Codigo ASCCI [null -> Hexadecimal]
		mov buffer[si],al
endm

```

El macro GetOpen es el encargo de abrir el archivo.

```java
; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm

```


Este macro es el encargado de cerrar el archivo por medio del handle.

```java
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
```

Este macro es el encargo de obtener toda la información del archivo **.jso**.
```java
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm

```

___
### Main<a name="main"></a>

El  main tiene la siguiente estructura

```java
; Teclado español con keyb la
; Teclado ingeles con keyb us

; ================ [SEGMENTO][LIBS] ================
include Macros.asm
include File.asm

.model small 

; ================ [SEGMENTO][STACK] ================
.stack 


; ================ SEGMENTO DE DATOS ================
.data  
        ;db -> dato byte -> 8 bits
	;dw -> dato word -> 16 bits
	;dd -> doble word -> 32 bits

	; ************** [IDENTIFICADOR] **************
	_cadena0        db 0ah,0dh,               "===================================================","$"
	_cadena1        db 0ah,0dh,               "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$","$"
	_cadena2        db 0ah,0dh,               "FACULTAD DE INGENIERIA$","$"
	_cadena3        db 0ah,0dh,               "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
	_cadena4        db 0ah,0dh,               "ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1", "$"
	_cadena5        db 0ah,0dh,               "SECCION A", "$"
	_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
	_cadena7        db 0ah,0dh,               "201800937$"

; ================ SEGMENTO DE PROC ================

; **************************** [IDENTIFICADOR] **************************** 
	identificador proc far
	    GetPrint _cadena0
	    GetPrint _cadena1
	    GetPrint _cadena2
	    GetPrint _cadena3
	    GetPrint _cadena4
	    GetPrint _cadena5
	    GetPrint _cadena6
	    GetPrint _cadena7
	    ret
	identificador endp

.code 
	main proc

		MOV AX, @data ; segmento de datos
		MOV DS, AX ; mover a ds
		MOV ES, AX
        CALL identificador
        jmp Lout
        Lout:
			;GetPrint _salto

			;reporte

			MOV ah,4ch
			int 21h

	main endp

end main
```

