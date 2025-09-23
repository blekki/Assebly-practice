project_name = sum

compile:
	nasm -f elf32 ${project_name}.asm -o ${project_name}.o

link:
	ld -m elf_i386 ${project_name}.o -o run
	
execute:
	./run

all: compile link clear-o

clear-o:
	rm *.o