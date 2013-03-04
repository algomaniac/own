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
