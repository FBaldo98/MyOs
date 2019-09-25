[bits 32]

; CONSTANTS
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; Prints a null-terminated string pointed to by EBX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	; Set edx to the start of vid mem

print_string_pm_loop:
	mov al, [ebx]		; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK	; Store attributes in AH

	cmp al, 0		; Check end string
	je print_string_pm_done

	mov [edx], ax		; Store char and attrib at current
				; Char cell
	add ebx, 1		; Move to next char in string
	add edx, 2		; Move to next char cell (2 bytes - char + attrib)

	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret
