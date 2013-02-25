CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
OBJDUMP = objdump

ASFLAGS =

# If the makefile can't find QEMU, specify its path here
QEMU = kvm

bootblock: boot.S
	$(AS) $(ASFLAGS) -f bin -o bootblock boot.S
	$(OBJDUMP) -D -b binary -mi386 bootblock > bootblock.asm

ifndef CPUS
CPUS := 2
endif
QEMUOPTS = -hdb bootblock -smp $(CPUS) -m 512 $(QEMUEXTRA)

qemu: bootblock
	$(QEMU) -serial mon:stdio $(QEMUOPTS)
