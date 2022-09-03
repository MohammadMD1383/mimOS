; ╔═══════════════════════════════════════════╗
; ║          Global Descriptor Table          ║
; ╚═══════════════════════════════════════════╝
;
; ├─8 bits─┼───8 bits───┼──8 bits───┼─8 bits─┤
; ┌────────┬─┬─┬─┬─┬────┬─┬──┬─┬────┬────────┐
; │  Base  │G│D│L│A│S.L.│P│DP│S│Type│  Base  │
; └────────┴─┴─┴─┴─┴────┴─┴──┴─┴────┴────────┘
;
; ├─────16 bits────┼─────16 bits────┤
; ┌────────────────┬────────────────┐
; │      Base      │  Segment Limit │
; └────────────────┴────────────────┘
;
; G: Granularity - if set, it multiplies the limit by 0xFFF (<< 3)
; D: Default operation size - 1: 32 bit, 0: 16 bit
; L: 64 bit code segment
; A: Available for use by system software - can be used e.g. for debugging
; S.L.: Segment limit
; P: Segment present
; DP: Descriptor privilege level - 0 is the highest
; S: Descriptor type: 1: code/data, 0: system
; Type: Segment type
;   ├─ Code: 1: code, 0: data
;   ├─ Conforming: by not conforming, it means code in a segment with a lower privilege may not call code in this segment
;   ├─ Readable: 1: yes, 0: no
;   └─ Accessed: this is often used for debugging and virtual memory techniques

gdt_start:
	; starting null 8-bytes for gdt
	dq 0

gdt_code:
	dw 0xFFFF    ; Segment Limit
	dw 0         ; Base
	db 0         ; Base
	db 10011010b ; P,DP,S,Type
	db 11001111b ; G,D,L,A,S.L.
	db 0         ; Base

gdt_data:
	dw 0xFFFF    ; Segment Limit
	dw 0         ; Base
	db 0         ; Base
	db 10010010b ; P,DP,S,Type
	db 11001111b ; G,D,L,A,S.L.
	db 0         ; Base

gdt_end:


; ├────16 bits─────┼─────────────32 bits────────────┤
; ┌────────────────┬────────────────────────────────┐
; │    gdt size    │           gdt address          │
; └────────────────┴────────────────────────────────┘
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start


CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start