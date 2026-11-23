NASM=nasm
LD=ld
ARM_AS=arm-none-eabi-as
ARM_LD=arm-none-eabi-ld
AARCH64_AS=aarch64-linux-gnu-as
AARCH64_LD=aarch64-linux-gnu-ld

all: helloworld_x86 helloworld_x86_64 helloworld_arm32 helloworld_aarch64

helloworld_x86: helloworld_x86.o
	$(LD) -m elf_i386 -o $@ $^

helloworld_x86.o: helloworld_x86.s
	$(NASM) -f elf32 -o $@ $<

helloworld_x86_64: helloworld_x86_64.o
	$(LD) -o $@ $^

helloworld_x86_64.o: helloworld_x86_64.s
	$(NASM) -f elf64 -o $@ $<

helloworld_arm32: helloworld_arm32.o
	$(ARM_LD) -o $@ $^

helloworld_arm32.o: helloworld_arm32.s
	$(ARM_AS) -o $@ $<

helloworld_aarch64: helloworld_aarch64.o
	$(AARCH64_LD) -o $@ $^

helloworld_aarch64.o: helloworld_aarch64.s
	$(AARCH64_AS) -o $@ $<

clean:
	rm -f helloworld_x86 helloworld_x86_64 helloworld_arm32 helloworld_aarch64 *.o
