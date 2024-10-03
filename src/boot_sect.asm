[ORG 0x7c00]
KERNEL_OFFSET equ 0x1000  ; This is the memory offset to load the kernel to.

mov [BOOT_DRIVE], dl    ; BIOS stores our boot drive in DL, so it's best to
                        ; remember this for later.

mov bp, 0x9000         ; Set stack safely out of the way.
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm

jmp $

%include "src/print_string.asm"
%include "src/disk_load.asm"
%include "src/print_hex_word.asm"
%include "src/gdt.asm"
%include "src/switch_to_pm.asm"
%include "src/print_string_pm.asm"

[bits 16]

; Load kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET     ; Set up parameters for our disk_load routine, so
  mov dh, 15                ; that we load the first 15 sectors (excluding the
  mov dl, [BOOT_DRIVE]      ; boot sector) from the boot disk (i.e. our kernel
  call disk_load            ; code) to address KERNEL_OFFSET.
  ret

[bits 32]
; This is where we arrive after switching to, and initialising protected mode.
BEGIN_PM:
  mov ebx, MSG_PROT_MODE  ; Use our 32-bit print routine to announce that we
  call print_string_pm    ; are in protected mode.

  call KERNEL_OFFSET      ; Now jump to the address of our loaded kernel code,
                          ; assume the brace position, and cross your fingers!
                          ; Here we go!

  jmp $                   ; Hang.

; Global variables
BOOT_DRIVE: db 0;
MSG_LOAD_KERNEL: db "Loading kernel into memory...", 0xA, 0xD, 0
MSG_REAL_MODE: db "Started in 16-bit Real Mode", 0xA, 0xD, 0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xAA55
