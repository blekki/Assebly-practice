section .text
    global _start

_start:
    mov eax, [num1]      ; first number
    add eax, [num2]      ; add second number
    add eax, '0'    ; convert into ascii char
    mov [sum], eax    ; save

    ; print sum   
    mov ecx, sum
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80

    ; get next line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80

    ; exit
    mov eax, 1
    int 0x80
    
section .data
    newline db 0x0A     ; '\n'
    newline_len equ $ - newline

    num1 dd 4
    num2 dd 5
    sum  dd 0