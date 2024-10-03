# Variables
ASM = nasm
ASM_FLAGS = -f bin
QEMU = qemu-system-i386 -fda
OD = od
OD_FLAGS = -A n -v
OD_OCTAL_FLAG = -t o1
OD_HEX_FLAG = -t x1
OD_BINARY_FLAG = -t b1

# Files
BIN = bin/os.bin
IMG = bin/os.img
SRC = $(wildcard src/boot*.asm)
#OBJ = $(patsubst src/%.asm, obj/%.o, $(SRC))
OCTAL_DUMP = dump/octal.dump
HEX_DUMP = dump/hex.dump

run: clean default
	$(QEMU) ./$(IMG)

default: $(IMG)

clean:
	rm -f obj/*.o
	rm -f bin/*
	rm -f dump/*

$(IMG): $(BIN)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BIN) of=$(IMG) conv=notrunc

$(BIN): $(SRC)
	$(ASM) $(ASM_FLAGS) -o $(BIN) $(SRC)

$(OCTAL_DUMP): $(IMG)
	$(OD) $(OD_FLAGS) $(OD_OCTAL_FLAG) $(BIN) > $(OCTAL_DUMP)

$(HEX_DUMP): $(IMG)
	$(OD) $(OD_FLAGS) $(OD_HEX_FLAG) $(BIN) > $(HEX_DUMP)

octal: $(OCTAL_DUMP)
hex: $(HEX_DUMP)
dump: octal hex

.PHONY: octal hex dump
#obj/%.o: src/%.c
#	gcc -c $< -o $@ -Iinclude

