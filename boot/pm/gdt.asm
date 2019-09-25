; GDT
gdt_start:

gdt_null:		; Mandatory null descriptor
	dd 0x0 		; 'dd' means define double word (4 bytes)
	dd 0x0

gdt_code:		; Code segment descriptor
	; base=0x0, limit=0xffffff
	; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
	; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
	; 2nd flags: (granularity)1 (32bit default)1 (64bit seg)0 (AVL)0 -> 1100b
	dw 0xffff	; Limit 0-15
	dw 0x0		; Base 0-15
	db 0x0		; Base 16-23
	db 10011010b	; 1st flags, type flags
	db 11001111b	; 2nd flags, limit 15-19
	db 0x0		; Base 24-31

gdt_data: 	; data segment
	; Same as code except for type flags
	; type flags: (code)0 (expand_down)0 (writable)1 (accessed)0 -> 0010b
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:		; The reason for t his label is so we can have
			; the compiler calculate the size of the GDT
			; for the GDT descriptor

; GDT Descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1	; Size of our GDT, always less one
					; of true size
	dd gdt_start			; Start address of GDT

; Define some handy constants for the GDT segment descripto offsets, which
; are what segment registers myst contain when in protected mode.
; For example, when we set DS = 0x10 in PM, the CPU knows that we mean it to use
; the segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which
; in our case is the DATA segment (0x0 -> NULL, 0x08 -> CODE, 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
	
