; laod DH sectors to ES:BX from drive DL
disk_load:
	push dx		; store DX ons stack so later we can recall
			; how many sectore were reqeusted
	mov ah, 0x02	; BIOS read sector function
	mov al, dh	; Read DH sectors
	mov ch, 0x00	; Select cylinder 0
	mov dh, 0x00	; Select head 0
	mov cl, 0x02	; Start reading from second sector

	int 0x13	; BIOS interrupt

	jc disk_error	; Jump if error

	pop dx		; restore DX
	cmp dh, al	; if AL (sectors read) != DH (sectors expected)
	jne disk_error
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

; Variables
DISK_ERROR_MSG	db "Disk read error!", 0
