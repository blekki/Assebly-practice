section .text
    global _start

_start:
    mov     eax, 4
    add     eax, 5
    add     eax, 48     ; ascii standart
    push    eax         ; push value in stack

    ; print
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, esp    ; copy value from the stack
    mov     edx, 1
    int     0x80

    pop eax             ; remove value from stack

    ; exit
    mov     eax, 1
    int     0x80