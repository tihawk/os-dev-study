[ORG 0x7c00]
[bits 16]

start:
  mov si, message
  call print_string

  jmp $

print_string:
  mov bx, 0
.again:
  lodsb
  cmp al, 0
  je .done
  call print_char
  jmp .again

.done:
  ret

; Input: AL <- byte to print
print_char:
  mov ah, 0x0e
  int 0x10
  ret

message: db 'Hello World!', 0

times 510-($-$$) db 0
dw 0xAA55
