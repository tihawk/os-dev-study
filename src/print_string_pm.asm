[bits 32]

; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; Input <- EBX
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY

.again:
  mov al, [ebx]
  mov ah, WHITE_ON_BLACK

  cmp al, 0
  je .done

  mov [edx], ax
  inc ebx
  add edx, 2    ; Move to nex character cell in video memory
  jmp .again

.done:
  popa
  ret
