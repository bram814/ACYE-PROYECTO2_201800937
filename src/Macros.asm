; **************************** [MACROS] ****************************
; ************** [IMPRIMIR] **************
clean macro
	mov ax,03h
    int 10h
endm

; ************** [IMPRIMIR] **************
GetPrint macro cadena
	mov ah,09h
	mov dx, offset cadena
	int 21h
endm


; ************** [CAPTURAR ENTRADA] **************
GetInput macro 
	MOV AH,01H ; 1 char
	int 21H
endm

GetText macro buffer, num
	LOCAL char, out
	xor si, si
	char:
		GetInput
		cmp al, 0dh
		je out
		mov buffer[si],al
		inc si
		cmp si, num
		je out
		jmp char
	out:
		mov al,24h
		mov buffer[si],al
endm




SerchUser macro user, compare
	LOCAL Lout, L0, L00, L1 , L11
	push si
	push di
	push ax
	
	xor si, si
	xor di, di
	xor ax, ax
	mov _flagUser, 0

	GetOpenFile _bufferInput,_handleInput                          ; Abrir file
	GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo 
	GetCloseFile _handleInput  

	xor si, si
	xor di, di
	xor ax, ax

	L0:
		xor al, al
		mov al, _bufferInfo[si]			; user1,

		cmp al, 2ch ; Codigo ASCCI [, -> Hexadecimal]
		je L00
		cmp al, 2Dh ; Codigo ASCCI [- -> Hexadecimal]
		je Lout
		cmp al, 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je Lout

		mov compare[di], al

		inc si
		inc di

		jmp L0

	L00:
		mov compare[di], 24h
		Verify user, compare

		cmp _flagUser, 1
		je Lout

		xor di, di
		inc si
		jmp L1

	L1:
		xor al, al
		mov al, _bufferInfo[si]			; user1,

		cmp al, 3bh ; Codigo ASCCI [; -> Hexadecimal]
		je L11
		cmp al, 2Dh ; Codigo ASCCI [- -> Hexadecimal]
		je Lout
		cmp al, 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je Lout

		;mov compare[di], al

		inc si 
		inc di

		jmp L1

	L11:
		;mov compare[di], 24h
		xor di, di
		inc si
		inc si
		jmp L0

	Lout:
		pop ax
		pop di
		pop si

endm



Verify macro user1, compare
	LOCAL Lout, L0, L1
	push si
	push di
	push ax
	
	xor si, si
	xor di, di
	xor ax, ax

	L0:
		xor al, al
		mov al, user1[si]

		cmp al, 24h   ; $
		je L1
		cmp al, compare[si]
		jne Lout
		inc si

		jmp L0

	L1:
		cmp compare[si], 24h
		jne Lout
		GetPrint _false
		GetPrint _salto
		mov _flagUser, 1
		jmp Lout


	Lout:
		pop ax
		pop di
		pop si

endm



VerifyPass macro pass1, flag
	LOCAL Lout, L1, L0, L2, Lerror
	push ax
	push si
	push di

	xor ax, ax
	xor si, si
	xor di, di

	L0:
		cmp pass1[si], 30h  ; 0 
		je L1
		cmp pass1[si], 31h 	; 1
		je L1
		cmp pass1[si], 32h  ; 2
		je L1
		cmp pass1[si], 33h 	; 3
		je L1
		cmp pass1[si], 34h 	; 4
		je L1
		cmp pass1[si], 35h 	; 5
		je L1
		cmp pass1[si], 36h 	; 6
		je L1
		cmp pass1[si], 37h 	; 7
		je L1
		cmp pass1[si], 38h 	; 8
		je L1
		cmp pass1[si], 39h 	; 9
		je L1


		cmp pass1[si], 24h 	; $
		je L2

		jmp Lerror

	L1:	
		inc si
		jmp L0

	L2:
		jmp Lout

	Lerror:
		GetPrint _false1
		GetPrint _salto
		mov flag, 1
	Lout:
		pop di
		pop si
		pop ax

endm




login macro user, compare, flag1, pass, compare2, flag2
	LOCAL Lout, L0, L00, L1 , L11, Le, Lerror
	push si
	push di
	push ax
	
	xor si, si
	xor di, di
	xor ax, ax
	mov flag1, 0
	mov flag2, 0

	GetOpenFile _bufferInput,_handleInput                          ; Abrir file
	GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo 
	GetCloseFile _handleInput  

	xor si, si
	xor di, di
	xor ax, ax

	L0:
		xor al, al
		mov al, _bufferInfo[si]		

		cmp al, 2ch ; Codigo ASCCI [, -> Hexadecimal]
		je L00
		cmp al, 2Dh ; Codigo ASCCI [- -> Hexadecimal]
		je Lout
		mov compare[di], al

		inc si
		inc di

		jmp L0

	L00:
		mov compare[di], 24h
		
		loginVerify compare, user, flag1

		xor di, di
		inc si
		jmp L1

	L1:
		xor al, al
		mov al, _bufferInfo[si]			; user1,

		cmp al, 3bh ; Codigo ASCCI [; -> Hexadecimal]
		je L11
		cmp al, 2Dh ; Codigo ASCCI [- -> Hexadecimal]
		je Lout

		mov compare2[di], al

		inc si 
		inc di

		jmp L1

	L11:
		mov compare2[di], 24h

		xor di, di
		inc si
		inc si

		cmp flag1, 1
		je Le
		jne L0

		Le:
			loginVerify compare2, pass, flag2
			cmp flag2, 0
			je Lerror

			GetPrint _salto
			GetPrint _false4
			GetPrint user
			GetPrint _salto
			jmp Lout
			Lerror:
				GetPrint _salto
				GetPrint _false3
				GetPrint _salto
				GetPrint _salto
				mov flag1, 0
				mov flag2, 0

				pop ax
				pop di
				pop si

				jmp Lf0

		
		jmp L0

	Lout:
		pop ax
		pop di
		pop si

endm


loginVerify macro user1, compare, flag
	LOCAL Lout, L0, L1
	push si
	push di
	push ax
	
	xor si, si
	xor di, di
	xor ax, ax

	L0:
		xor al, al
		mov al, user1[si]

		cmp al, 24h   ; $
		je L1
		cmp al, compare[si]
		jne Lout
		inc si
		jmp L0

	L1:
		cmp  compare[si], 24h
		jne Lout
		mov flag, 1
		jmp Lout


	Lout:
		pop ax
		pop di
		pop si

endm

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
  mov bx,0ah                ; Divisor: 10
  test ax,1000000000000000  ; veritficar si es numero negativo (16 bits)
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h   ; Se agrega un CERO para que sea un numero de dos digitos
      inc si
      jmp div10
  signoN:                   ; Cambiar de Signo el numero 
      neg ax                ; Se niega el numero para que sea positivo
      mov intNum[si], 2dh   ; Se agrega el signo negativo a la cadena de salida
      inc si
      jmp unDigito
  div10:
      xor dx, dx            ; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx                ; Se divide entre 10
      inc cx                ; Se incrementa el contador
      push dx               ; Se guarda el residuo DX
      cmp ax,0h             ; Si el cociente es CERO
      je obtenerDePila
      jmp div10
  obtenerDePila:
      pop dx                ; Obtenemos el top de la pila
      add dl,30h            ; Se le suma '0' en su valor ascii para numero real
      mov intNum[si],dl     ; Metemos el numero al buffer de salida
      inc si
      loop obtenerDePila
      mov ah, '$'           ; Se agrega el fin de cadena
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
  mov bx, 000Ah                     ;multiplicador 10
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh                   ; compara para ignorar el "-"
      jz ciclo                      ; Se ignora el simbolo '-' de la cadena
      cmp cl, 30h                   ; Si el caracter es menor a '0', implica que es negativo (verificacion)
      jb verificarNegativo          ; ir para cuando es un negativo 
      cmp cl, 39h                   ; Si el caracter es mayor a '9', implica que es negativo (verificacion)
      ja verificarNegativo
      sub cl, 30h                   ; Se le resta el ascii '0' para obtener el número real
      mul bx                        ; multplicar ax
      mov ch, 00h
      add ax, cx                    ; sumar para obtener el numero total
      jmp ciclo
  negacionRes:
      neg ax                        ; negacion por si es negativo el resultado
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh         ; Si existe un signo al inicio del numero, negamos el numero
      jz negacionRes
  salida:
                                    ; Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
endm


; ======================================== CARRO =================================
auxdiblinea macro vector, tam
;se le mueve a di en la posicion en la que se empezara a dibujar
;esta macro sirve para dibujar una linea
    mov di, ax
    mov si, offset vector
    mov cx, tam
    rep movsb
endm


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


dibujarCarro0 macro
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    auxdiblinea carro0Fila1, 11
    add ax, 320
    auxdiblinea carro0Fila2, 11
    add ax, 320
    auxdiblinea carro0Fila3, 11
    add ax, 320
    auxdiblinea carro0Fila4, 11
    add ax, 320
    auxdiblinea carro0Fila5, 11
    add ax, 320
    auxdiblinea carro0Fila6, 11
endm


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




dibujardis macro
;macro para dibujar el disparo por primera vez
    push cx
    xor cx, cx
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    pop cx
    auxdiblinea disparoFila1, 1
    add ax, 320
    auxdiblinea disparoFila2, 1
    add ax, 320
    auxdiblinea disparoFila3, 1
    add ax, 320
    auxdiblinea disparoFila4, 1
endm


redibujardis macro
;macro que sirve para ir moviendo el disparo hacia arriba
    local e1, salir, quitardisparo, salir1
    ;aqui valida que haya un disparo 
    cmp ydis, 0
    je salir
    ;cada vez que se repinta 5 veces la pantalla va a subir el disparo 1 pixel
    ;inc contador
    ;cmp contador, 5
    ;je e1
    ;jne salir
    e1:
    sub ax, 10
    mov ydis, ax
    dibujardis
    mov contador, 0
    salir:
    cmp ydis, 22
    jb quitardisparo
    jne salir1
    quitardisparo:
    mov ydis, 0
    mov xdis, 0
    salir1:
endm


imprimirnombre macro
    local e1, e2
    mov dl, 0
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset _user
        mov ah, 09h
        int 21h
    e2:
endm

imprimirPunteo macro
    local e1, e2
    mov dl, 20
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset _PUNTEO
        mov ah, 09h
        int 21h
    e2:
endm

imprimirVideo macro buffer, columna
    local e1, e2
    mov dl, columna
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset buffer
        mov ah, 09h
        int 21h
    e2:
endm

imprimirPausa macro
    local e1, e2
    mov dl, 10
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset _Pausa
        mov ah, 09h
        int 21h
    e2:
endm



; imprimirPantalla macro text, fila
;     local e1, e2
;     mov dl, 0
;     e1:
;     posicion del cursor
;         mov ah, 02h
;         ;dh fila
;         mov dh, fila
;         dl columna
;         mov dl, dl
;         int 10h
;         mov dx, offset text
;         mov ah, 09h
;         int 21h
;     e2:
; endm


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

dibujarmarco macro
    local e1, e2, e3, e4, e5
    ;convertir las coordenadas x y y para la lineazalizacion 
    ;se multiplican por 320 que es el ancho de la matriz la posicion en y
    mov cx, 320
    mul cx
    ;al resultado se le suma la posicion en x
    add ax, bx
    mov di, ax
    e1:
        ;comienza a dibujar el marco desde arriba
        auxdiblinea lineamarco, 20;0
        add ax, 20;
        auxdiblinea lineamarco, 20;20
        add ax, 20 ; ax = 20 + 20
        auxdiblinea lineamarco, 20;40
        add ax, 20
        auxdiblinea lineamarco, 20;60
        add ax, 20
        auxdiblinea lineamarco, 20;80
        add ax, 20
        auxdiblinea lineamarco, 20;100
        add ax, 20
        auxdiblinea lineamarco, 20;120
        add ax, 20
        auxdiblinea lineamarco, 20;140
        add ax, 20
        auxdiblinea lineamarco, 20;160
        add ax, 20
        auxdiblinea lineamarco, 20;180
        ;segunda linea marco
        add ax, 140; ax=320
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 340
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 360
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 380
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 400
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 420
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 440
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 460
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 480
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 500
        auxdiblinea lineamarco, 20
        ;empieza a dibujar lado izquierdo
        add ax, 140
        ;ax = 640
        auxdiblinea lineamarco1, 2
        push ax
        ;se guarda ax con 640
        xor si, si
    e2:
        push si
        ;se le suman 320 para llegar a la siguiente linea
        add ax, 320
        ;se dibuja la linea vertical de la izquierda
        auxdiblinea lineamarco1, 2
        pop si
    e3:
        inc si
        cmp si, 170
        jne e2
    
        pop ax
        ;ax = 640
        add ax, 198
        ;se le suman 198 porque toda la linea tiene una longitud de 200
        ;se dibuja la linea vertical de la derecha
        auxdiblinea lineamarco1, 2
        xor si, si
    e4:
        push si
        add ax, 320
        auxdiblinea lineamarco1, 2
        pop si
    e5:
        ;se dibujan las dos lineas del marco de abajo
        inc si
        cmp si, 170
        jne e4
        sub ax, 198
        ;se le restan 198 para regresar al inicio de la posicion en x
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 140
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
endm




GetPlay macro 
    local LCarro0, LCarro1, LCarro2, LCarro3, LCarro4, LCarro5, LCarro6, LCarro7, LCarro8, LCarro9, LCarro10, LCarro11, LCarro12, LCarro13, LCarro14, LCarro15, LCarro16, LCarro17, Lmov, Pausa, inicioj, inicioj1, tiempo1, masseg, masmin, inicioj2, WaitNotVSync, WaitNotVSync2, WaitVSync, WaitVSync2, disparar, disparar1, moverizq, moverder, finj, salir

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
    mov xcarro1, 65
    mov ycarro1, 50
    ; carro 2
    mov xcarro2, 75
    mov ycarro2, 35
    ; carro 3
    mov xcarro3, 95
    mov ycarro3, 25
    ; carro 4
    mov xcarro4, 105
    mov ycarro4, 60
    ; carro 5
    mov xcarro5, 115
    mov ycarro5, 56
    ; carro 6
    mov xcarro6, 125
    mov ycarro6, 85
    ; carro 7
    mov xcarro7, 135
    mov ycarro7, 36
    ; carro 8
    mov xcarro8, 145
    mov ycarro8, 56
    ; carro 9
    mov xcarro9, 155
    mov ycarro9, 90
    ; carro 10
    mov xcarro10, 165
    mov ycarro10, 100
    ; carro 11
    mov xcarro11, 175
    mov ycarro11, 56
    ; carro 12
    mov xcarro12, 185
    mov ycarro12, 90
    ; carro 13
    mov xcarro13, 195
    mov ycarro13, 110
    ; carro 14
    mov xcarro14, 205
    mov ycarro14, 50
    ; carro 15
    mov xcarro15, 215
    mov ycarro15, 130
    ; carro 16
    mov xcarro16, 225
    mov ycarro16, 80
    ; carro 17
    mov xcarro17, 235
    mov ycarro17, 30
    ;set tiempo en 0
    mov segundos, 0
    mov minutos, 0
    mov micsegundos, 0
    mov inicialTime, 0

    inicioj:
        mov ah, 0
        mov al, 13h
        int 10h
     
        ;se guardan los valores de los registros ax y bx ya que se modificaran 
        push ax
        push bx
        imprimirnombre
        imprimirtiempo 
        imprimirPunteo
        inc ycarro0 ; incre carro 0
        inc ycarro1 ; incre carro 1
        inc ycarro2 ; incre carro 2
        inc ycarro3 ; incre carro 3
        inc ycarro4 ; incre carro 4
        inc ycarro5 ; incre carro 5
        inc ycarro6 ; incre carro 6
        inc ycarro7 ; incre carro 7
        inc ycarro8 ; incre carro 8
        inc ycarro9 ; incre carro 9
        inc ycarro10 ; incre carro 10
        inc ycarro11 ; incre carro 11
        inc ycarro12 ; incre carro 12
        inc ycarro13 ; incre carro 13
        inc ycarro14 ; incre carro 14
        inc ycarro15 ; incre carro 15
        inc ycarro16 ; incre carro 16
        inc ycarro17 ; incre carro 17
        mov ax, _PUNTEOI
        Int_String _PUNTEOS
        imprimirVideo _PUNTEOS, 28

        Lmov:
            cmp ycarro0, 185   ; carro 0
            je LCarro0
            cmp ycarro1, 185   ; carro 1
            je LCarro1
            cmp ycarro2, 185   ; carro 2
            je LCarro2
            cmp ycarro3, 185   ; carro 3
            je LCarro3
            cmp ycarro4, 185   ; carro 4
            je LCarro4
            cmp ycarro5, 185   ; carro 5
            je LCarro5
            cmp ycarro6, 185   ; carro 6
            je LCarro6
            cmp ycarro7, 185   ; carro 7
            je LCarro7
            cmp ycarro8, 185   ; carro 8
            je LCarro8
            cmp ycarro9, 185   ; carro 9
            je LCarro9
            cmp ycarro10, 185   ; carro 10
            je LCarro10
            cmp ycarro11, 185   ; carro 11
            je LCarro11
            cmp ycarro12, 185   ; carro 12
            je LCarro12
            cmp ycarro13, 185   ; carro 13
            je LCarro13
            cmp ycarro14, 185   ; carro 14
            je LCarro14
            cmp ycarro15, 185   ; carro 15
            je LCarro15
            cmp ycarro16, 185   ; carro 16
            je LCarro16
            cmp ycarro17, 185   ; carro 17
            je LCarro17

            jmp inicioj1

            LCarro0:
                inc _PUNTEOI
                mov ycarro0, 23
                jmp Lmov
            LCarro1:
                inc _PUNTEOI
                mov ycarro1, 23
                jmp Lmov
            LCarro2:
                inc _PUNTEOI
                mov ycarro2, 23
                jmp Lmov
            LCarro3:
                inc _PUNTEOI
                mov ycarro3, 23
                jmp Lmov
            LCarro4:
                inc _PUNTEOI
                mov ycarro4, 23
                jmp Lmov
            LCarro5:
                inc _PUNTEOI
                mov ycarro5, 23
                jmp Lmov
            LCarro6:
                inc _PUNTEOI
                mov ycarro6, 23
                jmp Lmov
            LCarro7:
                inc _PUNTEOI
                mov ycarro7, 23
                jmp Lmov
            LCarro8:
                inc _PUNTEOI
                mov ycarro8, 23
                jmp Lmov
            LCarro9:
                inc _PUNTEOI
                mov ycarro9, 23
                jmp Lmov
            LCarro10:
                inc _PUNTEOI
                mov ycarro10, 23
                jmp Lmov
            LCarro11:
                inc _PUNTEOI
                mov ycarro11, 23
                jmp Lmov
            LCarro12:
                inc _PUNTEOI
                mov ycarro12, 23
                jmp Lmov
            LCarro13:
                inc _PUNTEOI
                mov ycarro13, 23
                jmp Lmov
            LCarro14:
                inc _PUNTEOI
                mov ycarro14, 23
                jmp Lmov
            LCarro15:
                inc _PUNTEOI
                mov ycarro15, 23
                jmp Lmov
            LCarro16:
                inc _PUNTEOI
                mov ycarro16, 23
                jmp Lmov
            LCarro17:
                inc _PUNTEOI
                mov ycarro17, 23
                jmp Lmov




            jmp inicioj1
        
        ; imprimirPantalla 
    inicioj1:
        mov ax, 20 ;y
        mov bx, 50 ;x
        dibujarmarco
        tiempo1:
            mov al, micsegundos
            inc al
            cmp al, 10
            je masseg
            mov micsegundos, al
            jmp inicioj2
        masseg:
            mov al, segundos
            inc al
            cmp al, 60
            je masmin
            mov segundos, al
            mov al, 0
            mov micsegundos, al
            jmp inicioj2
        masmin:
            mov al, minutos
            inc al
            mov minutos, al
            mov al, 0
            mov segundos, al
            mov micsegundos, al

    inicioj2:
        mov ax, ynave ;coordenada y de la nave
        mov bx, xnave ; coordenada x de la nave
        dibujarnave
        ; carro 0
        mov ax, ycarro0
        mov bx, xcarro0
        dibujarCarro0
        ; carro 1
        mov ax, ycarro1
        mov bx, xcarro1
        dibujarCarroN c1F1, c1F2, c1F3, c1F4, c1F5, c1F6
        ; carro 2
        mov ax, ycarro2
        mov bx, xcarro2
        dibujarCarroN c2F1, c2F2, c2F3, c2F4, c2F5, c2F6
        ; carro 3
        mov ax, ycarro3
        mov bx, xcarro3
        dibujarCarroN c3F1, c3F2, c3F3, c3F4, c3F5, c3F6
        ; carro 4
        mov ax, ycarro4
        mov bx, xcarro4
        dibujarCarroN c4F1, c4F2, c4F3, c4F4, c4F5, c4F6
        ; carro 5
        mov ax, ycarro5
        mov bx, xcarro5
        dibujarCarroN c5F1, c5F2, c5F3, c5F4, c5F5, c5F6
        ; carro 6
        mov ax, ycarro6
        mov bx, xcarro6
        dibujarCarroN c6F1, c6F2, c6F3, c6F4, c6F5, c6F6
        ; carro 7
        mov ax, ycarro7
        mov bx, xcarro7
        dibujarCarroN c7F1, c7F2, c7F3, c7F4, c7F5, c7F6
        ; carro 8
        mov ax, ycarro8
        mov bx, xcarro8
        dibujarCarroN c8F1, c8F2, c8F3, c8F4, c8F5, c8F6
        ; carro 9
        mov ax, ycarro9
        mov bx, xcarro9
        dibujarCarroN c9F1, c9F2, c9F3, c9F4, c9F5, c9F6
        ; carro 10
        mov ax, ycarro10
        mov bx, xcarro10
        dibujarCarroN c10F1, c10F2, c10F3, c10F4, c10F5, c10F6
        ; carro 11
        mov ax, ycarro11
        mov bx, xcarro11
        dibujarCarroN c11F1, c11F2, c11F3, c11F4, c11F5, c11F6
        ; carro 12
        mov ax, ycarro12
        mov bx, xcarro12
        dibujarCarroN c12F1, c12F2, c12F3, c12F4, c12F5, c12F6
        ; carro 13
        mov ax, ycarro13
        mov bx, xcarro13
        dibujarCarroN c13F1, c13F2, c13F3, c13F4, c13F5, c13F6
        ; carro 14
        mov ax, ycarro14
        mov bx, xcarro14
        dibujarCarroN c14F1, c14F2, c14F3, c14F4, c14F5, c14F6
        ; carro 15
        mov ax, ycarro15
        mov bx, xcarro15
        dibujarCarroN c1F1, c1F2, c1F3, c1F4, c1F5, c1F6
        ; carro 16
        mov ax, ycarro16
        mov bx, xcarro16
        dibujarCarroN c2F1, c2F2, c2F3, c2F4, c2F5, c2F6
        ; carro 17
        mov ax, ycarro17
        mov bx, xcarro17
        dibujarCarroN c6F1, c6F2, c6F3, c6F4, c6F5, c6F6
        ;se sacan los valores de ax y bx
        pop bx
        pop ax
        cmp inicialTime,0
        je Pausa
        ;se llaman los metodos para la sincronizacion de la pantalla
        ;esto se usa para que no titile tanto la pantalla
        mov dx, 03dah
        WaitNotVSync:
            in al, dx
            and al, 08h
            jnz WaitNotVSync
        WaitVSync:
            in al, dx
            and al, 08h
            jz WaitVSync

        mov dx, 03dah
        WaitNotVSync2:
            in al, dx
            and al, 08h
            jnz WaitNotVSync2
        WaitVSync2:
            in al, dx
            and al, 08h
            jz WaitVSync2

        ;call Delay; jugar con los valores del delay para que no titile tanto la pantalla
        mov cx, 0000h
        mov dx, 0fffffh
        mov ah, 86h
        int 15h
        ;call HasKey;este procedimiento verifica que se haya pulsado una tecla, si no regresa al inicio del juego a repintar la pantalla
        push ax
        mov ah, 01h
        int 16h
        pop ax
        jz inicioj
        call GetChar;verifica la tecla que pulso
        cmp al,1bh          ; escape
        je Pausa
        cmp ax, 4b00h;flecha de la izquierda
        je moverizq
        cmp ax, 4d00h;flecha de la derecha
        je moverder
        jmp inicioj;vuelve al inicio del juevo para repintar la pantalla
    moverizq:
        push ax
        mov ax, xnave; movemos la posicion de la nave al registro ax
        cmp ax, 52;comparamos si se puede mover a la izquierda, teniendo en cuenta que la coordenada x donde empieza el marco es la 50
        ;se le suman los dos pixeles de la linea vertical
        je inicioj;si es igual regresa al inicio del juego
        dec ax;si no es igual le resta 1 al valor de ax
        mov xnave, ax; se vuelve a asignar este valor a la coordena x de la nave
        pop ax
        jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
    moverder:
        push ax
        mov ax, xnave
        cmp ax, 237;se compara si se puede mover aun a la derecha, teniendo en cuenta que se empezo en la 50 y termino en la 250, a esto
        ;se le restan los 2 de la linea vertical quedando en 248, y aun se le debe restar los 11 del ancho de la nave dejando el resultado como 237
        je inicioj
        inc ax; si no es igual se incrementa el registro ax
        mov xnave, ax; se regresa a asignar el valor a la coordenada x de la nave
        pop ax
        jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
    Pausa:
        mov inicialTime, 1
        mov dl, 0; Column
        mov dh, 0 ; Row
        mov bx, 0 ; Page number, 0 for graphics modes
        mov ah, 2h
        int 10h
        mov ah, 09h
        mov al, spv 
        mov bh, 00h
        mov bl, 15d
        mov cx, 40d
        int 10h
        mov dl, 0; Column
        mov dh, 0 ; Row
        mov bx, 0 ; Page number, 0 for graphics modes
        mov ah, 2h
        int 10h
        imprimirnombre
        imprimirtiempo
        imprimirPausa
        imprimirPunteo
        imprimirVideo _PUNTEOS, 28
        call GetChar;verifica la tecla que pulso
        cmp al,1bh          ; escape
        je inicioj
        cmp al,20h          ; space
        je finj
        jmp Pausa

    finj:
        ;regresa el control de la pantalla a modo texto
        mov ax, 3h
        int 10h
        jmp salir
    salir:


        

endm

