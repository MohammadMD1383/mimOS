; ╔═══════════════════════════════════════╗
; ║          Bios Print Function          ║
; ╚═══════════════════════════════════════╝
; params
;   └─ bx: address of null-terminated char[]
print:
    pusha

    ; (bx -= 1) in order to add one by one when the loop starts
    sub bx, 1

    ; bios tty mode
    mov ah, 0x0E

print_loop:
	; while (1) {
	;   bx += 1;
	;   al = *bx;
	;   if (al == 0) goto end_print;
	;   interrupt(0x10);
	; }
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
; ║          Load Kernel Function          ║
; ╚════════════════════════════════════════╝
; params
;   ├─ es:bx: address to write to
;   ├─ dh: number of sectors to read
;   └─ dl: drive number [optional: as bios will set this for us]
load_kernel:
	pusha
	push dx

	mov ah, 2  ; bios read disk function
	mov al, dh ; number of disk sectors to read
	mov cl, 2  ; disk sector to start read from
	mov ch, 0  ; disk cylinder
	mov dh, 0  ; disk head
	int 0x13   ; bios interrupt
	jc  load_kernel_disk_error

	pop dx

	cmp al, dh ; bios will set al to number of sectors read
	jne load_kernel_sectors_error

	popa
	ret

load_kernel_disk_error:
	mov bx, disk_error_msg
	call print
	jmp $ ; hang

load_kernel_sectors_error:
	mov bx, sectors_error_msg
	call print
	jmp $ ; hang

disk_error_msg:
	db "DISK ERROR", 0
sectors_error_msg:
	db "SECTOR ERROR", 0


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