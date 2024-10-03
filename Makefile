# Variables
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386 -fda
OD = od
OD_FLAGS = -A n -v
OD_OCTAL_FLAG = -t o1
OD_HEX_FLAG = -t x1

# Files
BOOT_SEC_SRC = $(wildcard src/boot*.asm)
BOOT_SEC_BIN = bin/boot.bin
KERNEL_ENTRY_SRC = src/kernel_entry.asm
KERNEL_ENTRY_OBJ = obj/kernel_entry.o
KERNEL_SRC = $(wildcard src/*.c)
KERNEL_OBJ = $(patsubst src/%.c, obj/%.o, $(KERNEL_SRC))
KERNEL_BIN = bin/kernel.bin
OS_BIN = bin/os.bin
OS_IMG = bin/os.img
OCTAL_DUMP = dump/octal.dump
HEX_DUMP = dump/hex.dump

run: clean default
	$(QEMU) ./$(OS_IMG)

default: $(OS_IMG)

clean:
	rm -f obj/*
	rm -f bin/*
	rm -f dump/*

$(OS_IMG): $(OS_BIN)
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$? of=$@ conv=notrunc

$(OS_BIN): $(BOOT_SEC_BIN) $(KERNEL_BIN)
	cat $? > $@

# BOOT SECTOR

$(BOOT_SEC_BIN): $(BOOT_SEC_SRC)
	$(ASM) $(ASM_FLAGS) -o $@ $?

$(OCTAL_DUMP): $(OS_BIN)
	$(OD) $(OD_FLAGS) $(OD_OCTAL_FLAG) $? > $@

$(HEX_DUMP): $(OS_BIN)
	$(OD) $(OD_FLAGS) $(OD_HEX_FLAG) $? > $@

octal: $(OCTAL_DUMP)
hex: $(HEX_DUMP)
dump: octal hex

# KERNEL

$(KERNEL_BIN): $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ)
	ld -o $@ -Ttext 0x1000 $? --oformat binary

$(KERNEL_ENTRY_OBJ): $(KERNEL_ENTRY_SRC)
	$(ASM) $? -f elf64 -o $@

$(KERNEL_OBJ): $(KERNEL_SRC)
	gcc -ffreestanding -c $? -o $@

.PHONY: octal hex dump
