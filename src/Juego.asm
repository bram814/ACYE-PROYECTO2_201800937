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

	; ************** [JUEGO] **************
	SPVar db " ","$"
	TNivel db " Nivel:","$"
	EPuntos db " Puntos:","$"
	tabulacion db "	","$"
	NumCero db "0","$"
	sigDP db ":","$"
	titulo_pausa db "                PAUSA               ","$"

	;---------VARIABLES JUEGO---------

	NivelPrint db 10 dup('$')
	ValorSegundos db 0
	SegundosAux WORD 0
	MinutosAux WORD 0
	PuntajeAux db 0
	TiempoAux db 0
	TiempoMeta WORD 0
	NivelesCompletados WORD 0
	ContadorNivel db 1
	Taux WORD 0
	TOaux WORD 0
	TPaux WORD 0
	PPaux WORD 0
	POaux WORD 0
	CCaux db 0
	;---------------------------------
	NivelGeneral db 1
	ColorCarro db 13d
	StringSize WORD 0
	Velocidad WORD 0
	Segundos WORD 0
	ValorDelay WORD 10100101101b
	ColumnaCarro WORD 10101010b
	AnchoBarra WORD 10
	AlturaMax WORD 150
	AlturaAux WORD 0
	ValorMax WORD 0
	ColorAux db 15d
	HzAux WORD 100d
	InicioBarra WORD 0
	Separacion db 0
	Separacion2 db 0
	SeparacionAux db 0
	NumPrint db 100 dup('$')
	Num db 100 dup(00h)



	;**************************************************************************
	bufferEntrada db 50 dup('$'),00
	bufferAuxiliar db 50 dup('$')
	handlerEntrada dw ?
	bufferPuntos db "Puntos.rep",00h
	handlerPuntos dw ?
	bufferTiempo db "Tiempo.rep",00h
	handlerTiempo dw ?
	bufferInformacion db 300 dup('$')
	bufferInfoAux db 200 dup('$')
	bufferFechaHora db 15 dup('$')
	NBytes WORD 0
	IDAux db 10 dup('$')
	IDAuxFile db 10 dup(00h)
	TotalUsuarios WORD 0
	TotalNiveles WORD 0
	OffsetUsuario WORD 0
	NivelAux WORD 0
	UsuarioAux WORD 0
	OFFSETAux WORD 0
	Valores db 25 dup (0)
	intAux WORD 0
	AuxVar db 0
	intCont WORD 0
	NumeroAux WORD 0
	Contador1 WORD 0
	Contador2 WORD 0
	Contador3 WORD 0
	Contador4 WORD 0

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
			Juego	
			RegresarATexto
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

	ConvertirNum proc
            push bp                    ;almacenamos el puntero base
            mov  bp,sp                 ;ebp contiene la direccion de esp
            sub  sp,2                  ;se guarda espacio para dos variables
            mov word ptr[bp-2],0       ;var local =0 
            ;pusha
            LimpiarBuffer Num, SIZEOF Num, 00h
            xor si,si                          ;si=0
            cmp ax,0                           ;si ax, ya viene con un cero
            je casoMinimo           
            mov  bx,0                          ;denota el fin de la cadena
            push bx                            ;se pone en la pila el fin de cadena
            Bucle:  
                mov dx,0
                cmp ax,0                    ;¿AX= 0?
                je toNum                    ;si:enviar numero al arreglo                
                mov bx,10                   ;divisor  = 10
                div bx                      ;ax =cociente ,dx= residuo
                add dx,48d                   ;residuo +48 para  poner el numero en ascii
                push dx                     ;lo metemos en la pila 
                jmp Bucle
            toNum:
                pop bx                      ;obtenemos elemento de la pila
                mov word ptr[bp-2],bx       ; pasamos de 16 bits a 8 bits 
                mov al, byte ptr[bp-2]
                cmp al,0                    ;¿Fin de Numero?
                je FIN                      ;si: enviar al fin del procedimiento
                mov num[si],al              ;ponemos el numero en ascii en la cadena
                inc si                      ;incrementamos los valores               
                jmp toNum                   ;iteramos de nuevo            
            casoMinimo:
                add al,48d                         ;convertimos 0 ascii
                mov Num[si],al                     ;Lo pasamos a num
                jmp FIN
            FIN:
                ;popa
                mov sp,bp               ;esp vuelve apuntar al inicio y elimina las variables locales
                pop bp                  ;restaura el valor del puntro base listo para el ret
                ret 
    ConvertirNum endp

	ConvertirPrint proc
            push bp                   
            mov  bp,sp                
            sub  sp,2                 
            mov word ptr[bp-2],0      
            ;pusha
            LimpiarBuffer NumPrint, SIZEOF NumPrint, 24h
            xor si,si                        
            cmp ax,0                        
            je casoMinimo2         
            mov  bx,0                       
            push bx                          
            Bucle2:  
                mov dx,0
                cmp ax,0                   
                je toNum2                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp Bucle2
            toNum2:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je FIN2                  
                mov NumPrint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov NumPrint[si],al                
                jmp FIN2
            FIN2:
                ;popa
                mov sp,bp           
                pop bp                
                ret 
    ConvertirPrint endp


end main