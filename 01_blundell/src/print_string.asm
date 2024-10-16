print_string:
  push bx
.again:
  mov al, [bx]
  or al, al
  jz .done
  mov ah, 0x0e
  int 0x10
  inc bx
  jmp .again
.done:
  pop bx
  ret
