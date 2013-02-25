[BITS 16]	      ; Tell compliler that it's 16 bit
[ORG 0x7C00]
main:
mov ax,0x0000	;
mov ds,ax	;
mov si,welcome	;
call printstr	;
jmp main

printstr:
mov ah,0x0E	;int function
mov bh,0x00	;?
mov bl,0x07	;display attribute

nextchar:
lodsb		; load [SI] into AL and  SI+1
or al,al	;
jz return	;
int 0x10	;
jmp nextchar	;
return:
ret

welcome db 'init stage0',13,10,0

times 510-($-$$) db 0 ; boot loader has to be 512 bytes , this tells
		      ; fill in rest with 0's
dw 0xAA55	      ; magic word
