[bits 16]
switch_to_32:
	; disable interrupts
	cli

	; load gdt
	lgdt [gdt_descriptor]

	; enable 32-bit mode
	mov eax, cr0
	or  eax, 1
	mov cr0, eax

	; perform far jump
	jmp CODE_SEG:init_32


[bits 32]
init_32:
	; update registers
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; update stack
	mov ebp, 0x9F000
	mov esp, ebp

	; start 32-bit mode
	call begin_32
