; Teclado español con keyb la
; Teclado ingeles con keyb us

; ================ [SEGMENTO][LIBS] ================
include Macros.asm
include File.asm
; include Video.asm

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
				jne Lplay

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


		Lplay:
			; clean
			; Juego	
			jmp Lsalida

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