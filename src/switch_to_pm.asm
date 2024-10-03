[bits 16]
; Switch to protected mode
switch_to_pm:
  cli                   ; We must switch off interrupts until we have set up the
                        ; protected mode interrupt vector, otherwise interrupts
                        ; will run riot

  lgdt [gdt_descriptor] ; Load our global descriptor table, which defines the
                        ; protexted mode segments (e.g. for code and data)

  mov eax, cr0          ; To make the switch to protected mode, we set the first
  or eax, 0x1           ; bit of cr0, a control register
  mov cr0, eax

  jmp CODE_SEG:init_pm  ; Make a far jump (i.e. to a new segment) to our 32-bit
                        ; code. This also forces the CPU to flush its cache of
                        ; pre-fetched and real-mode decoded instructions, which
                        ; can cause problems

[bits 32]
; Initialise registers and the stack once in protected mode
init_pm:
  
  mov ax, DATA_SEG      ; Now in PM, our old segments are meaningless, so we
  mov ds, ax            ; point our segment registers to the data selector we
  mov ss, ax            ; defined in our GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000      ; Update our stack position, so it's right at the top
  mov esp, ebp          ; of the free space

  call BEGIN_PM         ; Finally, call some well-known label

