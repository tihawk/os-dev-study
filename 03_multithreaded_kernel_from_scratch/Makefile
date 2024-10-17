# Files
BOOT_SRC = src/boot.asm
BOOT_BIN = bin/boot.bin

run: clean default
	qemu-system-x86_64 -hda $(BOOT_BIN)

clean:
	rm -f $(BOOT_BIN)

default: $(BOOT_BIN)

$(BOOT_BIN): $(BOOT_SRC)
	nasm -f bin $< -o $@
