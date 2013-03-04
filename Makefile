CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
OBJDUMP = objdump

ASFLAGS =

# If the makefile can't find QEMU, specify its path here
QEMU = kvm

bootblock: bootblock.S
	$(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c main.c	
	$(AS) $(ASFLAGS) -f elf -o bootblock.o bootblock.S
	$(LD) $(LDFLAGS) -N -e main -Ttext 0x7C00 --oformat binary -o bootsector bootblock.o main.o
	$(OBJDUMP) -D -b binary -mi386 bootsector > bootblock.asm

ifndef CPUS
CPUS := 2
endif
QEMUOPTS = -hdb bootsector -smp $(CPUS) -m 512 $(QEMUEXTRA)

qemu: bootblock
	$(QEMU) -serial mon:stdio $(QEMUOPTS)

clean:
	rm *.o
	rm bootsector
