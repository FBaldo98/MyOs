C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = $(C_SOURCES:.c=.o)

all: os-image

os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

.c.o:
	gcc -ffreestanding -c $< -o $@

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf64 -o $@

boot/boot_sect.bin: boot/boot_sect.asm
	nasm $< -f bin -I 'boot/'  -o $@

clean:
	rm -fr *.bin *.dis *.o os-image *.map
	rm -fr kernel/*.o boot/*.bin drivers/*.o

