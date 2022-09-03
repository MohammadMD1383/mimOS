; set offset to start of boot sector loaded in memory
[org 0x7C00]

; where we load kernel in memory
KERNEL_MAIN equ 0x500

; set stack
mov bp, 0x9000
mov sp, bp

; load kernel
mov  bx, KERNEL_MAIN
mov  dh, 1
call load_kernel

; change to 32-bit mode
call switch_to_32


; include other files
%include "include/asm/util.asm"
%include "include/asm/gdt.asm"
%include "include/asm/mode32.asm"


[bits 32]
begin_32:
	call KERNEL_MAIN


; fill remaining space with zero
times 510 - ($-$$) db 0

; boot sector magic
dw 0xAA55
