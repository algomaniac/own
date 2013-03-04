;*********************************************
;	Segment access type
;*********************************************

%define STA_X     0x8       ; Executable segment
%define STA_E     0x4       ; Expand down (non-executable segments)
%define STA_C     0x4       ; Conforming code segment (executable only)
%define STA_W     0x2       ; Writeable (non-executable segments)
%define STA_R     0x2       ; Readable (executable segments)
%define STA_A     0x1       ; Accessed


;*********************************************
;	Segment offsets
;*********************************************
%define SEG_KCODE 1  // code segment
%define SEG_KDATA 2  // kernel data+stack


;*********************************************
;	Control Register flags
;*********************************************
 
%define CR0_PE          0x00000001      ; Protection Enable
