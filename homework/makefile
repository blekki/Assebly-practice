main = hw1

compile:
	nasm -f elf32 ${main}.asm -o ${main}.o

link:
	ld -m elf_i386 ${main}.o -o run
	
execute:
	./run

all: compile link clear-o

clear-o:
	rm *.o

# --- Special commands for a cuple works ---

# complile printer
preparation:
	nasm -f elf32 inc/printer.inc  -o inc/printer.o
	nasm -f elf32 inc/intToStr.inc -o inc/intToStr.o

# complile project with dependencies
compile-plus:
	nasm -f elf32 ${main}.asm -o ${main}.o
	ld -m elf_i386 ${main}.o inc/printer.o inc/intToStr.o -o run
	rm ${main}.o
	