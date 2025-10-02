section .text
    global _start

_start:

    ; ### stack as buffer ###
    sub esp, 10     ; reserve stack
    
    cld
    lea edi, [esp]  ; in current situation [esp] it's our [buffer]
    mov al, '1'     ; value
    xor ecx, ecx    ; clear ecx register
    mov cl, 10      ; repeat times
    rep stosb

    ; print
    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 10
    int 0x80
    
    add esp, 10     ; clear stack after all

    ; ### reserved data as buffer ###
    ; fill first part
    cld
    lea edi, [buffer]
    mov al, '2'     ; value
    xor ecx, ecx    ; clear ecx register
    mov cl, 5       ; repeat times
    rep stosb

    ; fill second part
    cld
    lea edi, [buffer + 5]
    mov al, '3'     ; value
    xor ecx, ecx    ; clear ecx register
    mov cl, 5       ; repeat times
    rep stosb

    ; print
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 10     
    int 0x80
    
    ; exit
    mov eax, 1
    int 0x80

section .bss
    buffer: resb 10