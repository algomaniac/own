;
; assembler macros to create x86 segments
;

%macro SEG_NULL  0                                           
        dd 0                                         
        dd 0
%endmacro

; The 0xC0 means the limit is in 4096-byte units
; and (for executable segments) 32-bit mode.
; TODO : why is limit and base considered to have 
; different endian.

%macro SEG_DESC 3	;(base,lim,type)                                  
        dw (((%2) >> 12) & 0xffff) 
	dw ((%1) & 0xffff);      
        db (((%1) >> 16) & 0xff)
	db (0x90 | (%3))         
        db (0xC0 | (((%2) >> 28) & 0xf)) 
	db (((%1) >> 24) & 0xff)
%endmacro

%define STA_X     0x8       ; Executable segment
%define STA_E     0x4       ; Expand down (non-executable segments)
%define STA_C     0x4       ; Conforming code segment (executable only)
%define STA_W     0x2       ; Writeable (non-executable segments)
%define STA_R     0x2       ; Readable (executable segments)
%define STA_A     0x1       ; Accessed


;*********************************************
;	Control Register flags
;*********************************************
 
%define CR0_PE          0x00000001      ; Protection Enable
