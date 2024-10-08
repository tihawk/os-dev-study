; GDT
gdt_start:

gdt_null: ; The mandatory null descriptor
  dd 0x0
  dd 0x0

gdt_code: ; The code segment descriptor
  ; base=0x0, limit=0xffff,
  ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 0b1001
  ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 0b1010
  ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 0b1100
  dw 0xffff       ; Limit (bits 0-15)
  dw 0x0          ; Base (bits 0-15)
  db 0x0          ; Base (bits 16-23)
  db 0b10011010   ; 1st flags, type flags
  db 0b11001111   ; 2nd flags, Limit (bits 16-19)
  db 0x0          ; Base (bits 24-31)

gdt_data: ; The data segment descriptor
  ; base=0x0, limit=0xffff,
  ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 0b1001
  ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0b1010
  ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 0b1100
  dw 0xffff       ; Limit (bits 0-15)
  dw 0x0          ; Base (bits 0-15)
  db 0x0          ; Base (bits 16-23)
  db 0b10010010   ; 1st flags, type flags
  db 0b11001111   ; 2nd flags, Limit (bits 16-19)
  db 0x0          ; Base (bits 24-31)

gdt_end:          ; The reason for putting a label at the end of the GDT is so
                  ; we can have the assembler calculate the size of the GDT for
                  ; the GDT descriptor (below)

; GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1  ; Size of our GDT, always one less than the true size
  dd gdt_start                ; Start of the address of our GDT

; Define some handy constants for the GDT segment descriptor offsets, which are
; what segment registers must contain when in protected mode. For example, when
; we set DS = 0x10 in PM, the CPU knows that we mean it to use the segment
; described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our case is the
; DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
