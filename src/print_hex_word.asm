; Input: AX contains the word (16-bit address) to print in hex
print_hex_word:
    push ax

    ; Print high byte (AH)
    mov al, ah            ; Move AH to AL (get the high byte)
    call print_hex_byte   ; Print the high byte

    ; Print low byte (AL)
    pop ax                ; Restore AX (AL contains the low byte)
    call print_hex_byte   ; Print the low byte
    ret

; Input: AL <- byte to print
print_hex_byte:
    push ax

    ; Print high nibble
    mov ah, al    ; Move AL to AH (AX = AL)
    shr al, 4     ; Shift right to get the high nibble into AL
    call print_hex_nibble

    ; Print the low nibble
    pop ax        ; Restore AX (AL contains the original byte)
    and al, 0x0F  ; Mask out the upper nibble to get the low nibble
    call print_hex_nibble
    ret

; Input: AL contains a nibble
print_hex_nibble:
    cmp al, 9          ; Check if it's a digit
    jbe .digit
    add al, 'A' - 10   ; If it's not, convert to ASCII letter A-F
    jmp .done

.digit:
    add al, '0'       ; If a digit, convert to ASCII number 0-9

.done:
    ; Print the ASCII character
    mov ah, 0x0E
    int 0x10
    ret
