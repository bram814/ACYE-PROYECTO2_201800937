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