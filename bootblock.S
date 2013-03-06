%include "macros.inc"
%include "bootblock.inc"

bits 16	      ; Tell compliler that it's 16 bit
	      ; elf do not support org 0x7C00

global start
extern bootmain
;*********************************************
;	Bootloader Entry Point
;*********************************************
start:
 cli		; disable bios enabled intrpts
 ;zero segment registers DS,SS and ES
 xor ax,ax	;
 mov ds,ax	;
 mov es,ax	;
 mov ss,ax	;

  ;Physical address line A20 is tied to zero so that the first PCs 
  ;with 2 MB would run software that assumed 1 MB.  Undo that.

 seta20.1:
  in     al,0x64               ;Wait for not busy
  test   al,0x2
  jnz    seta20.1

  mov     al,0xD1               ;0xd1 -> port 0x64
  out      0x64,al

seta20.2:
  in      al,0x64               ;Wait for not busy
  test    al,0x2
  jnz     seta20.2

  mov    al,0xdf               ;0xdf -> port 0x60
  out    0x60,al


 ;switching from real to protected using bootstrap GDT
 ;which maps virtual address directly to physical so the 
 ;memory map do not change

 lgdt [gdtdesc]
 mov eax,cr0
 or  eax,CR0_PE
 mov cr0,eax
 
 ;make along jump to reload cs and ip
 ;below is same as 0x8:start32 , our code selector is at 8 bytes 
 ;off [gdtdesc ]
 jmp 0x08:start32

;*********************************************
;	32bit world
;*********************************************

bits 32	
start32:
;setup protected mode data segment registers 
;SEG_KDATA<<3 = 16 
mov ax ,0x10
mov ds,ax	;data
mov es,ax	;extra
mov ss,ax	;stack

mov ax,0	;segments not ready for use
mov fs,ax	;
mov gs,ax	;

mov esp,start  ;
call bootmain  ;

;loop:
;   nop
;jmp loop
ret

gdt:
	SEG_NULL				;null segment
	SEG_DESC 0x0,0xffffffff,STA_R|STA_X 	;code segment
	SEG_DESC 0x0,0xffffffff,STA_W 		;data segment
gdtdesc:
	dw (gdtdesc - gdt -1) 
	dd gdt

;times (510-($-$$)) db 0 ; boot loader has to be 512 bytes , this tells
		      ; fill in rest with 0's
;dw 0xAA55	      ; magic word
