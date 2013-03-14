CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
OBJDUMP = objdump
CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector
ASFLAGS =

# If the makefile can't find QEMU, specify its path here
QEMU = kvm

bootblock: bootblock.S
	$(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c bootmain.c	
	$(AS) $(ASFLAGS) -f elf -o bootblock.o bootblock.S
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00  -o bootsector.o bootblock.o bootmain.o
	$(OBJCOPY) -S -O binary -j .text bootsector.o bootsector
	./sign.pl bootsector

ifndef CPUS
CPUS := 2
endif
QEMUOPTS = -hdb bootsector -smp $(CPUS) -m 512 $(QEMUEXTRA)

qemu: bootblock
	$(QEMU) -serial mon:stdio $(QEMUOPTS)

clean:
	rm *.o
	rm bootsector
	rm *.d
