;
; PRINT_HEX
; Print hex value contained in DX
;

print_hex:

	pusha		; Save registers for later

	mov cx, 4	; Counter, we want to print 4 chars
			; 4 bits per char, 16 bits

char_loop:
	dec cx		; decrement the counter
	
	mov ax, dx	; copy dx into ax, so we can mask
	shr dx, 4
	and ax,0xf	; mask to get the last 4 bits

	mov bx, HEX_OUT ; set bx to memory addres of the string
	add bx, 2	; skips 0x
	add bx, cx	; add the counter offset

	cmp ax,0xA	; Check if it is a letter or number
	jl set_letter	; if number, set in the string
	add ax, 0x27	; if letter, add 0x27
	
set_letter:
	add al, 0x30	; For ASCII add 0x30
	mov byte [bx],al; Add the value of byte to the char at bx

	cmp cx, 0	; Check counter
	je end_hex
	jmp char_loop

end_hex:
	mov bx, HEX_OUT
	call print_string

	popa
	ret

HEX_OUT: db '0x0000',13,10, 0 
