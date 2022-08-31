; set offset to start of boot sector loaded in memory
[org 0x7C00]

; set stack
mov bp, 0x9000
mov sp, bp

; print text
mov bx, text
call print

; change to 32-bit mode
call switch_to_32

; hang
jmp $


; include other files
%include "util.asm"
%include "gdt.asm"
%include "mode32.asm"


[bits 32]
begin_32:
	mov ebx, text_32
	call print_32
	jmp $


; variables
text:
    db "Hello World From Assembly", 0
text_32:
	db "Hello World in 32-bit", 0

; fill remaining space with zero
times 510 - ($-$$) db 0

; boot sector loader magic
dw 0xAA55
