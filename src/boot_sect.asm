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

mov bx, HELLO_MSG
call print_string

jmp $

%include "src/print_string.asm"
%include "src/disk_load.asm"
%include "src/print_hex_word.asm"

BOOT_DRIVE: db 0;
HELLO_MSG: db 'Hello, World!', 0

times 510-($-$$) db 0
dw 0xAA55

times 256 dw 0xdada
times 256 dw 0xface
