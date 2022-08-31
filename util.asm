; ╔═══════════════════════════════════════╗
; ║          Bios Print Function          ║
; ╚═══════════════════════════════════════╝
print:
    pusha

    ; bx is param #1 (address of null-terminated char[])
    ; (bx -= 1) in order to add one by one when the loop starts
    sub bx, 1

    ; bios tty mode
    mov ah, 0x0E

; while (1) {
;   bx += 1;
;   al = *bx;
;   if (al == 0) goto end_print;
;   interrupt(0x10);
; }
print_loop:
    add bx, 1
    mov al, [bx]
    cmp al, 0
    je  print_end
    int 0x10
    jmp print_loop

print_end:
    popa
    ret


; ╔════════════════════════════════════════╗
; ║       32-bit Mode Print Function       ║
; ╚════════════════════════════════════════╝
VIDEO_MEMORY   equ 0xB8000
WHITE_ON_BLACK equ 0x0F

[bits 32]
print_32:
	pusha

	; set video memory position - top-left of the screen
	mov edx, VIDEO_MEMORY

	; ah is the color
	mov ah, WHITE_ON_BLACK

	; ebx is param #1 (address of null-terminated char[])
	; (ebx -= 1) because in each loop cycle we will increase it by 1
	sub ebx, 1

print_32_loop:
	add ebx, 1
	; al is the character
	mov al, [ebx]
	cmp al, 0
	je  print_32_end
	mov [edx], ax
	add edx, 2
	jmp print_32_loop

print_32_end:
	popa
	ret