; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm


; ============================== REPORTE ==============================

; ************** [PATH][CREATE] **************
GetCreateFile macro buffer,handler
    MOV AX,@data
    MOV DS,AX
    MOV AH,3ch
    MOV CX,00h
    LEA DX,buffer
    INT 21h
    ;jc Error4
    MOV handler, AX
endm
; ************** [PATH][WRITE] **************
GetWriteFile macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX
    ; MOV AH,40h
    ; MOV BX,handler
    ; MOV CX, SIZEOF buffer 

    XOR BX, BX
    XOR AX, AX 
    ciclo_Ini:
      MOV AL, buffer[ BX ]
      CMP AL, '$'
      JE ciclo_Fin

      INC BX 
      JMP ciclo_Ini
    ciclo_Fin:
    XOR AX, AX

    MOV contadorBuffer, BX
    XOR BX, BX
    
    MOV AH,40h
    MOV BX,handler
    MOV CX, contadorBuffer
    LEA DX, buffer
    INT 21h
endm
