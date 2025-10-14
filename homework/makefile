project_name = hw1

compile:
	nasm -f elf32 ${project_name}.asm -o ${project_name}.o

link:
	ld -m elf_i386 ${project_name}.o -o run
	
execute:
	./run

all: compile link clear-o

clear-o:
	rm *.o

# special compile command for the hw4
file1 = hw4
file2 = printer
file3 = intToStr
hw4-compile:
	nasm -f elf32 ${file1}.asm -o ${file1}.o
	nasm -f elf32 inc/${file2}.inc -o ${file2}.o
	nasm -f elf32 inc/${file3}.inc -o ${file3}.o
	ld -m elf_i386 ${file1}.o ${file2}.o ${file3}.o -o run
	rm *.o
	