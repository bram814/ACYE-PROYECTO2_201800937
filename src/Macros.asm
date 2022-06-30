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

print macro cadena
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


; ============================== VIDEO ==============================
getCharSE macro ; sin echo
	mov ah,08h
	int 21h
endm


InicioVideo macro
	mov ax,0013h
	int 10h
	mov ax, 0A000h
	mov es, ax  ; es = A000h - MEMORIA DE LOS GRAFICOS.
endm

Delay macro constante
	LOCAL D1,D2,Fin
	push si
	push di
	mov si,constante
	D1:
	dec si
	jz Fin
	mov di,constante
	D2:
		dec di
		jnz D2
		jmp D1
	Fin:
		pop di
		pop si
endm

LimpiarBuffer macro buffer, NoBytes, Char
	LOCAL Repetir
	xor si,si
	xor cx,cx
	mov cx,NoBytes
	Repetir:
		mov buffer[si], Char
		inc si
		loop Repetir
endm

DecToPrint macro NumeroDec
    push ax     
    mov ax,NumeroDec
    call ConvertirPrint
    pop ax
endm

PintarEncabezadoJuego macro
	LOCAL PintarLinea, ImprimirConCero, ImprimirConCero2, LineaC, ImprimirSegundos
	mov dl, 0; Column
	mov dh, 0 ; Row
	mov bx, 0 ; Page number, 0 for graphics modes
	mov ah, 2h
	int 10h
	mov ah, 09h
	mov al, SPVar 
	mov bh, 00h
	mov bl, 15d
	mov cx, 40d
	int 10h
	mov dl, 0; Column
	mov dh, 0 ; Row
	mov bx, 0 ; Page number, 0 for graphics modes
	mov ah, 2h
	int 10h
	print IDAux
	print TNivel
	xor cx,cx
	mov cl,NivelGeneral
	DecToPrint cx
	print NumPrint
	print EPuntos
	xor cx,cx
	mov cl,PuntajeAux
	DecToPrint cx
	print NumPrint
	print tabulacion


	mov cx, MinutosAux
	cmp cx,9
	jle ImprimirConCero
	DecToPrint MinutosAux
	print NumPrint
	jmp ImprimirSegundos
	ImprimirConCero:
		print NumCero
		DecToPrint MinutosAux
		print NumPrint	
	ImprimirSegundos:
		print sigDP
		mov cx,SegundosAux
		cmp cx,9
		jle ImprimirConCero2
		DecToPrint SegundosAux
		print NumPrint
		jmp LineaC
	ImprimirConCero2:
		print NumCero
		DecToPrint SegundosAux
		print NumPrint
	LineaC:
		mov di,3200
		mov cx,320
		mov dl,9d
	PintarLinea:
		mov es:[di],dl
		inc di
		Loop PintarLinea
endm

PintarCarro macro color
	LOCAL PrimerFor, SegundoFor
	mov dl,color
	mov bx,54400
	add bx,ColumnaCarro
	mov cx,0
	SegundoFor:
		mov di,bx
		xor si,si
	PrimerFor:
		mov es:[di],dl
		inc di
		inc si
		cmp si,20
		jne PrimerFor
		add bx,320
		inc cx
		cmp cx,25
		jbe SegundoFor
	endm

ValidarSegundo macro
	LOCAL SalirVS

	mov  ah, 2ch
	int  21h
	cmp dh,ValorSegundos
	je SalirVS
	mov ValorSegundos,dh
	AumentarSegundos

	SalirVS:
endm

AumentarSegundos macro
	LOCAL IncrementarMinutos, SalirAS
	inc TiempoAux
	inc TiempoMeta
	inc SegundosAux
	mov cx,SegundosAux
	cmp cx,60
	je IncrementarMinutos
	jmp SalirAS
	IncrementarMinutos:
		inc MinutosAux
		mov SegundosAux,0
	SalirAS:
endm

RegresarATexto macro
mov ah,00h
mov al,03h
int 10h
endm

Juego macro
	LOCAL Reload, SumarColumna, RestarColumna, SalirJuego, Sumar, Restar, CompararValores, ReemplazarP, ReemplazarT, ContinuarExit, Pausa
	
	mov ColumnaCarro, 10101010b
	mov NivelGeneral,1
	PintarEncabezadoJuego
	mov  ah, 2ch
	int  21h
	mov ValorSegundos,dh 
	mov PuntajeAux,3
	mov SegundosAux,0
	mov MinutosAux,0
	mov TiempoAux,0
	Reload:
		ValidarSegundo
		PintarEncabezadoJuego
		PintarCarro ColorCarro
		;getCharSE
		mov ah,11h
		int 16h
		jz Reload
		mov ah,00
		int 16h
		cmp ah,4dh			;derecha
		je SumarColumna
		cmp ah,4bh			;izquierda
		je RestarColumna
		cmp al,1bh			;ESC
		je Pausa
		jmp Reload

	SumarColumna:
		mov ax, ColumnaCarro
		cmp ax,300
		jb Sumar
		jmp Reload

	Sumar:
		inc PuntajeAux
		PintarEncabezadoJuego
		PintarCarro 0d
		mov ax,ColumnaCarro
		add ax,5
		mov ColumnaCarro,ax
		jmp Reload

	RestarColumna:
		mov ax,ColumnaCarro
		cmp ax,0
		ja Restar	
		jmp Reload

	Restar:
		PintarEncabezadoJuego
		PintarCarro 0d
		mov ax,ColumnaCarro
		sub ax,5
		mov ColumnaCarro,ax
		jmp Reload


	Pausa:
		mov dl, 0; Column
		mov dh, 0 ; Row
		mov bx, 0 ; Page number, 0 for graphics modes
		mov ah, 2h
		int 10h
		mov ah, 09h
		mov al, SPVar 
		mov bh, 00h
		mov bl, 15d
		mov cx, 40d
		int 10h
		mov dl, 0; Column
		mov dh, 0 ; Row
		mov bx, 0 ; Page number, 0 for graphics modes
		mov ah, 2h
		int 10h
		print titulo_pausa
		getCharSE
		cmp al,1bh			;ESC
		je Reload
		cmp al,20h			;SPACEBAR
		je SalirJuego
		jmp Pausa


	; ReemplazarP:
	; 	mov [bx].Usuario.Punteo,cl
	; 	jmp ContinuarExit

	; ReemplazarT:
	; 	mov [bx].Usuario.Tiempo,cl
	; 	jmp SalirJuego

	; CompararValores:
	; mov bx,UsuarioAux
	; mov al,[bx].Usuario.Punteo
	; mov cl,PuntajeAux
	; cmp al,cl
	; jl ReemplazarP
	; ContinuarExit:
	; 	mov al,[bx].Usuario.Tiempo
	; 	mov cl,TiempoAux
	; 	cmp al,cl
	; 	jl ReemplazarT

	SalirJuego:
endm

