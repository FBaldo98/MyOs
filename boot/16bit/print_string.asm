;
; PRINT_STRING ROUTINE
;
; Prints the null terminated string stored at the
; address contained in bx
;

print_string:
	pusha
	mov ah, 0x0E		; int 10h settings - BIOS Printing

loop:
	mov al, [bx]		; Move the first byte at address bx in al
	cmp al, 0		; Check if end of the string
	je end
	int 0x10		; Call interrupt for BIOS printing
	add bx, 0x1		; increment bx, going to next byte
	jmp loop		; print loop

end:
	popa
	ret			; Return
