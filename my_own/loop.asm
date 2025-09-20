section .text
    global _start

_start:
    mov ecx, 10     ;
    mov eax, '1'    ; load ascii symbol '1'

l1:
    mov [num], eax
    push ecx
    
    ; print
    mov eax, 4
    mov ebx, 1
    mov ecx, num    ; load what we wan't write
    mov edx, 1      ; len of symbol
    int 0x80

    ; get next number
    mov eax, [num]
    inc eax
    pop ecx
    
    loop l1         ; next loop iterration
;l1 end

    mov eax, 1
    int 0x80

section .bss
    num resb 1