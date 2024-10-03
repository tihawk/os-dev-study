[ORG 0x7c00]

mov [BOOT_DRIVE], dl    ; BIOS stores our boot drive in DL, so it's best to
                        ; remember this for later

mov bp, 0x8000         ; Set stack safely out of the way
mov sp, bp

mov bx, 0x9000          ; Load 5 sectors to 0 x0000 (ES ):0 x9000 (BX)
mov dh, 5               ;   from the boot disk
mov dl, [BOOT_DRIVE]
call disk_load

mov ax, [0x9000]
call print_hex_word

mov ax, [0x9000 + 512]
call print_hex_word

mov bx, MSG_HELLO
call print_string

; Switching to 32-bit protected mode

mov bp, 0x9000          ; Set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm

jmp $

%include "src/print_string.asm"
%include "src/disk_load.asm"
%include "src/print_hex_word.asm"
%include "src/gdt.asm"
%include "src/switch_to_pm.asm"
%include "src/print_string_pm.asm"

[bits 32]
; This is where we arrive after switching to, and initialising protected mode.
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm    ; Use our 32-bit print routine.

  jmp $

; Global variables
BOOT_DRIVE: db 0;
MSG_HELLO: db "Hello, World!", 0
MSG_REAL_MODE: db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xAA55

times 256 dw 0xdada
times 256 dw 0xface
