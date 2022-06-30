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

	; ************** [EXTRAS] **************
	_salto          db 0ah,0dh,               "$"
	_opcion         db 0ah,0dh,               "Ingrese Opcion: $"
	_tk_coma       	db			               ",$"
	_tk_puntocoma  	db 			               ";$"
	_false          db 0ah,0dh,                "Error, ese Usuario ya existe.$"
	_false1         db 0ah,0dh,                "Error, contrasena incorrecta.$"
	_false2         db 0ah,0dh,                "Usuario Incorrecto$"
	_false3         db 0ah,0dh,                "Contrasena Incorrecta$"
	_false4         db 0ah,0dh,                "Bienvenido, $"

	; ************** [ERRORES] **************
	_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
	_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
	_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
	_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
	_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
	_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
	_error7         db 0ah,0dh,               "> Error al crear el Archivo",            "$"

	; ************** [USUARIOS] **************
	_user1         db 			              "Ingrese el Usuario: ",            	"$"	
	_user2         db 			              "Ingrese la Contrasena: ",            "$"	

	_userS    db 50 dup('$'), "$"
	_passS    db 50 dup('$'), "$"


	; ************** [DECLARACIONES] **************
	_flagUser    	db 0
	_flagUPass    	db 0
	_user           db 15 dup('$'),"$"
	_pass           db 10 dup('$'),"$"


	; ************** [IDENTIFICADOR] **************
	_cadena0        db 0ah,0dh,               "-----------------------------------------------------", "$"
	_cadena1        db 0ah,0dh,               "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$","$"
	_cadena2        db 0ah,0dh,               "FACULTAD DE INGENIERIA$","$"
	_cadena3        db 0ah,0dh,               "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
	_cadena4        db 0ah,0dh,               "ARQUITECTURA DE COMPILADORES Y ENSAMBLADORES 1", "$"
	_cadena5        db 0ah,0dh,               "SECCION A", "$"
	_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
	_cadena7        db 0ah,0dh,               "201800937$"

	; ************** [MENU] **************
	
	_menu1         db 0ah,0dh,               "1. Ingresar",   	"$"
	_menu2         db 0ah,0dh,               "2. Registrar",    "$"
	_menu3         db 0ah,0dh,               "3. Salir",        "$"


	; ************** [FILE] **************
	_bufferInput    db 'users.usr',00h
	_handleInput    dw ? 
	_bufferInfo     db 2000 dup('$'),"$"
	contadorBuffer  dw 0 ; Contador para todos los WRITE FILE, para escribir sin que se vean los $


	; *********************** [VISTA DE JUEGO] ********************************
	spv       db " ","$"
	_Pausa    db " PAUSA $"
	_PUNTEO   db "Punteo: $"
	_PUNTEOI  dw 0
	_PUNTEOS  db 50 dup(' '), "$" 
	;coordenadas nave
	xnave           dw  0
	ynave           dw  0
	;marco
	lineamarco      db  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24 
	lineamarco1     db  24, 24
	; CARRO
	naveFila1       db  00, 00, 09, 09, 14, 14, 14, 09, 09, 00, 00
	naveFila2       db  00, 00, 09, 09, 10, 10, 10, 09, 09, 00, 00
	naveFila3       db  00, 00, 00, 00, 10, 10, 10, 00, 00, 00, 00
	naveFila4       db  00, 00, 00, 00, 10, 10, 10, 00, 00, 00, 00
	naveFila5       db  00, 00, 09, 09, 10, 10, 10, 09, 09, 00, 00
	naveFila6       db  00, 00, 09, 09, 39, 10, 39, 09, 09, 00, 00
	; carro 0
	xcarro0         dw  0
	ycarro0         dw  0
	carro0Fila1     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	carro0Fila2     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	carro0Fila3     db  00, 00, 00, 00, 39, 39, 39, 00, 00, 00, 00
	carro0Fila4     db  00, 00, 00, 00, 39, 39, 39, 00, 00, 00, 00
	carro0Fila5     db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	carro0Fila6     db  00, 00, 15, 15, 14, 14, 14, 15, 15, 00, 00
	; carro 1
	xcarro1         dw  0
	ycarro1         dw  0
	c1F1            db  00, 00, 15, 15, 06, 06, 06, 15, 15, 00, 00
	c1F2            db  00, 00, 15, 15, 06, 06, 06, 15, 15, 00, 00
	c1F3            db  00, 00, 00, 00, 06, 06, 06, 00, 00, 00, 00
	c1F4            db  00, 00, 00, 00, 06, 06, 06, 00, 00, 00, 00
	c1F5            db  00, 00, 15, 15, 06, 06, 06, 15, 15, 00, 00
	c1F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 2
	xcarro2         dw  0
	ycarro2         dw  0
	c2F1            db  00, 00, 15, 15, 03, 03, 03, 15, 15, 00, 00
	c2F2            db  00, 00, 15, 15, 03, 03, 03, 15, 15, 00, 00
	c2F3            db  00, 00, 00, 00, 03, 03, 03, 00, 00, 00, 00
	c2F4            db  00, 00, 00, 00, 03, 03, 03, 00, 00, 00, 00
	c2F5            db  00, 00, 15, 15, 03, 03, 03, 15, 15, 00, 00
	c2F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 3
	xcarro3         dw  0
	ycarro3         dw  0
	c3F1            db  00, 00, 15, 15, 05, 05, 05, 15, 15, 00, 00
	c3F2            db  00, 00, 15, 15, 05, 05, 05, 15, 15, 00, 00
	c3F3            db  00, 00, 00, 00, 05, 05, 05, 00, 00, 00, 00
	c3F4            db  00, 00, 00, 00, 05, 05, 05, 00, 00, 00, 00
	c3F5            db  00, 00, 15, 15, 05, 05, 05, 15, 15, 00, 00
	c3F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 4 ---
	xcarro4         dw  0
	ycarro4         dw  0
	c4F1            db  00, 00, 15, 15, 01, 01, 01, 15, 15, 00, 00
	c4F2            db  00, 00, 15, 15, 01, 01, 01, 15, 15, 00, 00
	c4F3            db  00, 00, 00, 00, 01, 01, 01, 00, 00, 00, 00
	c4F4            db  00, 00, 00, 00, 01, 01, 01, 00, 00, 00, 00
	c4F5            db  00, 00, 15, 15, 01, 01, 01, 15, 15, 00, 00
	c4F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 5 ---
	xcarro5         dw  0
	ycarro5         dw  0
	c5F1            db  00, 00, 15, 15, 02, 02, 02, 15, 15, 00, 00
	c5F2            db  00, 00, 15, 15, 02, 02, 02, 15, 15, 00, 00
	c5F3            db  00, 00, 00, 00, 02, 02, 02, 00, 00, 00, 00
	c5F4            db  00, 00, 00, 00, 02, 02, 02, 00, 00, 00, 00
	c5F5            db  00, 00, 15, 15, 02, 02, 02, 15, 15, 00, 00
	c5F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 6 ---
	xcarro6         dw  0
	ycarro6         dw  0
	c6F1            db  00, 00, 15, 15, 14, 14, 14, 15, 15, 00, 00
	c6F2            db  00, 00, 15, 15, 14, 14, 14, 15, 15, 00, 00
	c6F3            db  00, 00, 00, 00, 14, 14, 14, 00, 00, 00, 00
	c6F4            db  00, 00, 00, 00, 14, 14, 14, 00, 00, 00, 00
	c6F5            db  00, 00, 15, 15, 14, 14, 14, 15, 15, 00, 00
	c6F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 7 ---
	xcarro7         dw  0
	ycarro7         dw  0
	c7F1            db  00, 00, 15, 15, 12, 12, 12, 15, 15, 00, 00
	c7F2            db  00, 00, 15, 15, 12, 12, 12, 15, 15, 00, 00
	c7F3            db  00, 00, 00, 00, 12, 12, 12, 00, 00, 00, 00
	c7F4            db  00, 00, 00, 00, 12, 12, 12, 00, 00, 00, 00
	c7F5            db  00, 00, 15, 15, 12, 12, 12, 15, 15, 00, 00
	c7F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 8 ---
	xcarro8         dw  0
	ycarro8         dw  0
	c8F1            db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c8F2            db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c8F3            db  00, 00, 00, 00, 09, 09, 09, 00, 00, 00, 00
	c8F4            db  00, 00, 00, 00, 09, 09, 09, 00, 00, 00, 00
	c8F5            db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c8F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 9 ---
	xcarro9         dw  0
	ycarro9         dw  0
	c9F1            db  00, 00, 15, 15, 08, 08, 08, 15, 15, 00, 00
	c9F2            db  00, 00, 15, 15, 08, 08, 08, 15, 15, 00, 00
	c9F3            db  00, 00, 00, 00, 08, 08, 08, 00, 00, 00, 00
	c9F4            db  00, 00, 00, 00, 08, 08, 08, 00, 00, 00, 00
	c9F5            db  00, 00, 15, 15, 08, 08, 08, 15, 15, 00, 00
	c9F6            db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 10 ---
	xcarro10        dw  0
	ycarro10        dw  0
	c10F1           db  00, 00, 14, 14, 02, 02, 02, 14, 14, 00, 00
	c10F2           db  00, 00, 14, 14, 02, 02, 02, 14, 14, 00, 00
	c10F3           db  00, 00, 00, 00, 02, 02, 02, 00, 00, 00, 00
	c10F4           db  00, 00, 00, 00, 02, 02, 02, 00, 00, 00, 00
	c10F5           db  00, 00, 14, 14, 02, 02, 02, 14, 14, 00, 00
	c10F6           db  00, 00, 14, 14, 39, 39, 39, 14, 14, 00, 00
	; carro 11 ---
	xcarro11         dw  0
	ycarro11         dw  0
	c11F1            db  00, 00, 03, 03, 05, 05, 05, 03, 03, 00, 00
	c11F2            db  00, 00, 03, 03, 05, 05, 05, 03, 03, 00, 00
	c11F3            db  00, 00, 00, 00, 05, 05, 05, 00, 00, 00, 00
	c11F4            db  00, 00, 00, 00, 05, 05, 05, 00, 00, 00, 00
	c11F5            db  00, 00, 03, 03, 05, 05, 05, 03, 03, 00, 00
	c11F6            db  00, 00, 03, 03, 39, 39, 39, 03, 03, 00, 00
	; carro 12 ---
	xcarro12         dw  0
	ycarro12         dw  0
	c12F1            db  00, 00, 03, 03, 14, 14, 14, 03, 03, 00, 00
	c12F2            db  00, 00, 03, 03, 14, 14, 14, 03, 03, 00, 00
	c12F3            db  00, 00, 00, 00, 14, 14, 14, 00, 00, 00, 00
	c12F4            db  00, 00, 00, 00, 14, 14, 14, 00, 00, 00, 00
	c12F5            db  00, 00, 03, 03, 14, 14, 14, 03, 03, 00, 00
	c12F6            db  00, 00, 03, 03, 39, 39, 39, 03, 03, 00, 00
	; carro 13 ---
	xcarro13        dw  0
	ycarro13        dw  0
	c13F1           db  00, 00, 03, 03, 07, 07, 07, 03, 03, 00, 00
	c13F2           db  00, 00, 03, 03, 07, 07, 07, 03, 03, 00, 00
	c13F3           db  00, 00, 00, 00, 07, 07, 07, 00, 00, 00, 00
	c13F4           db  00, 00, 00, 00, 07, 07, 07, 00, 00, 00, 00
	c13F5           db  00, 00, 03, 03, 07, 07, 07, 03, 03, 00, 00
	c13F6           db  00, 00, 03, 03, 39, 39, 39, 03, 03, 00, 00
	; carro 14 ---
	xcarro14        dw  0
	ycarro14        dw  0
	c14F1           db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c14F2           db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c14F3           db  00, 00, 00, 00, 09, 09, 09, 00, 00, 00, 00
	c14F4           db  00, 00, 00, 00, 09, 09, 09, 00, 00, 00, 00
	c14F5           db  00, 00, 15, 15, 09, 09, 09, 15, 15, 00, 00
	c14F6           db  00, 00, 15, 15, 39, 39, 39, 15, 15, 00, 00
	; carro 15 ---
	xcarro15        dw  0
	ycarro15        dw  0
	; carro 16 ---
	xcarro16        dw  0
	ycarro16        dw  0
	; carro 17 ---
	xcarro17        dw  0
	ycarro17        dw  0
	;disparo
	disparoFila1    db  12
	disparoFila2    db  29
	disparoFila3    db  29
	disparoFila4    db  45
	;coordenadas disparo
	xdis            dw  0
	ydis            dw  0
	contador        dw  0
	;tiempo
	inicialTime    db  0
	minutos         db  0
	decminutos      db  0
	uniminutos      db  0
	segundos        db  0
	decsegundos     db  0
	unisegundos     db  0
	micsegundos     db  0

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
	    GetPrint _cadena0
	    GetPrint _salto
	    ret
	identificador endp

	menu proc far
	    GetPrint _menu1
	    GetPrint _menu2
	    GetPrint _menu3
	    GetPrint _salto
	    ret
	menu endp


	GetChar proc far
	;lee un caracter
	    xor ah, ah
	    int 16h
	    ret
	GetChar endp


	limpiarpantallag proc
	;vuelve a entrar en el modo video
	    mov ah, 0
	    mov al, 13h
	    int 10h
	    ret
	limpiarpantallag endp

	Delay proc far
	;metodo para agregar un delay en microsegundos para refrescar la pantalla
	;los microsegundos se toman como cx:dx
	    mov cx, 0000h
	    mov dx, 0fffffh
	    mov ah, 86h
	    int 15h
	    ret
	Delay endp

	HasKey proc
;verifica si se ha pulsado una tecla
    push ax
    mov ah, 01h
    int 16h
    pop ax
    ret
HasKey endp

; ================ SEGMENTO DE CODIGO ================
.code 
	main proc
		mov ax, @data
    	mov ds, ax
		clean

		Lidentificador:
			call identificador

		Lmenu:
			call menu
			GetPrint _opcion
			GetInput


			cmp al,31H 	; Codigo ASCCI [1 -> Hexadecimal]
	        je Loption1
	        cmp al,32H 	; Codigo ASCCI [2 -> Hexadecimal]
	        je Loption2
	        cmp al,33H 	; Codigo ASCCI [3 -> Hexadecimal]
	        je Lsalida 
	        jmp LMenu


	    Loption1:
	    	GetPrint _salto
			GetPrint _user1
			GetText _user, 7
			jmp Lf0

			Lf0:
				GetPrint _user2
				GetText _pass, 4

				login _user, _userS, _flagUser, _pass, _passS, _flagUPass 
				cmp _flagUser, 0
				GetPrint _salto
				GetPrint _false2
				GetPrint _salto
				je Loption1
				GetPlay
				jmp Lmenu



	    	jmp Lmenu
		
		Loption2:
			; clean 
			mov _flagUser, 0
			GetPrint _salto
			GetPrint _user1
			GetText _user, 7

			SerchUser _user, _userS; buscar user
			
			cmp _flagUser, 0
			je Lf
			jne Loption2
			Lf:

				mov _flagUPass, 0
				GetPrint _user2
				GetText _pass, 4

				VerifyPass _pass, _flagUPass
				cmp _flagUPass, 1
				je Lf

				GetCreateFile _bufferInput, _handleInput
				GetWriteFile _handleInput, _user
				GetWriteFile _handleInput, _tk_coma
				GetWriteFile _handleInput, _pass
				GetWriteFile _handleInput, _tk_puntocoma
				GetWriteFile _handleInput, _salto
				GetWriteFile _handleInput, _bufferInfo
				GetCloseFile _handleInput 

				; ; clean 
				; mov _flagUser, 0
				; mov _flagUPass, 0

				jmp Lmenu

			jmp Lmenu   




		 Lerror1:
	        GetPrint _salto
	        GetPrint _error1
	        jmp Lmenu
	    Lerror2:
	        GetPrint _salto
	        GetPrint _error2
	        jmp Lmenu
	    Lerror3:
	        GetPrint _salto
	        GetPrint _error3
	        jmp Lmenu
	    Lerror4:
	        GetPrint _salto
	        GetPrint _error4
	        jmp Lmenu
	    Lerror5:
	        GetPrint _salto
	        GetPrint _error5
	        jmp Lmenu
	    Lerror7:
	        GetPrint _salto
	        GetPrint _error7
	        jmp Lsalida


		Lsalida:
			;clean	
			MOV ah,4ch
			int 21h

	main endp

end main