run: clean default
	qemu-system-x86_64 -hda boot.bin

clean:
	rm -f boot.bin

default: boot.bin

boot.bin: boot.asm
	nasm -f bin $< -o $@
