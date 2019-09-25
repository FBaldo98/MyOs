[bits 32]
[extern main]		; Declare that we will be referencing the external
			; symbol 'main'. So the linker chan substitute the final address

call main		; Invoke main() in the C kernel
jmp $
