[BITS 16]	      ; Tell compliler that it's 16 bit
[ORG 0x7C00]

jmp main	;jump to main

;wait for input buffer clear
wait_input:		
 in al,0x64
 test al,2
 jnz wait_input	
 ret

;wait for output buffer full(plz read) 
wait_output:		
 in al,0x64
 test al,1
 jz wait_output
 ret

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

;--------------------------------------------
; Enables a20 line through output port
;--------------------------------------------

EnableA20:
	cli
	pusha

        call    wait_input
        mov     al,0xAD
        out     0x64,al		; disable keyboard
        call    wait_input

        mov     al,0xD0
        out     0x64,al		; tell controller to read output port
        call    wait_output

        in      al,0x60
        push    eax		; get output port data and store it
        call    wait_input

        mov     al,0xD1
        out     0x64,al		; tell controller to write output port
        call    wait_input

        pop     eax
        or      al,2		; set bit 1 (enable a20)
        out     0x60,al		; write out data back to the output port

        call    wait_input
        mov     al,0xAE		; enable keyboard
        out     0x64,al

        call    wait_input
	popa
        sti
        ret

;*********************************************
;	Bootloader Entry Point
;*********************************************

main:
 cli		; disable bios enabled intrpts
 ;zero segment registers DS,SS and ES
 xor ax,ax	;
 mov ds,ax	;
 mov ss,ax	;
 mov es,ax	;
 mov si,HELLO
 call printstr
 mov si,A20MSG
 call printstr
 call EnableA20 
 ret

A20MSG db 'enabling A20',13,10,0
HELLO db 'init stage0',13,10,0

times 510-($-$$) db 0 ; boot loader has to be 512 bytes , this tells
		      ; fill in rest with 0's
dw 0xAA55	      ; magic word
