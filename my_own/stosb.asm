section .text
    global _start

_start:

    sub esp, 10     ; reserve stack
    
    cld
    lea edi, [esp]  ; in current situation [esp] it's our [buffer]
    mov al, 49      ; value
    mov cl, 10      ; repeat times
    rep stosb

    ; print
    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 10
    int 0x80

    ; pre-exit
    add esp, 10     ; clear stack
    ; exit
    mov eax, 1
    int 0x80