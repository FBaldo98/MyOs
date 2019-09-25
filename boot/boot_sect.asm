[org 0x7c00]
KERNEL_OFFSET	equ 0x1000		; This is the kernel offset to which we will load
					; our kernel

	mov [BOOT_DRIVE], dl		; BIOS stores our boot drive in DL, so it's
					; best to remember it for later

	mov bp, 0x9000			; Set up the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel

	call switch_to_pm		; Switch to PM, from which we will never return

	jmp $

%include "16bit/print_string.asm"
%include "16bit/disk_load.asm"
%include "pm/gdt.asm"
%include "pm/print_string_pm.asm"
%include "pm/switch_to_pm.asm"

[bits 16]

; Load kernel
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET		; Set up parameters for our disk_load routine,
	mov dh, 15			; so that we load the first 15 sectors (excluding boot sector)
	mov dl, [BOOT_DRIVE]		; from the bootdisk to address KERNEL_OFFSET
	call disk_load			

	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET		; Now jump to the address of our loaded kernel code

	jmp $				; Hang

; Global Variables
BOOT_DRIVE	db 0
MSG_REAL_MODE	db "Started in 16 bit real mode", 13, 10, 0
MSG_PROT_MODE	db "Switched to 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 13, 10, 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
