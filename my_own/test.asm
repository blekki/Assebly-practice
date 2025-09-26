section .text   
    global _start

_start:

    mov eax, 123456     ; our parameter
    call intToStr

    ; exit
    mov eax, 1
    int 0x80


intToStr:
    mov cl, 1
    sub esp, 5
    mov byte  [esp + 4], cl    ; iter
    mov dword [esp    ], eax    ; our parameter
    
; { start loop
    xor ecx, ecx
l1: 
    mov [esp + 4], byte cl      ; save iter
    mov eax, [esp]

    cmp eax, 0
    ja a
    jmp ex
a:  
    inc byte [esp + 4]     ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor edx, edx    ; clear edx
    mov ebx, 10
    div ebx
    mov [esp], eax  ; save new basic number
    
    ; print remainder from division
    mov edi, edx    
    call printNum2

    mov cl, byte [esp + 4]      ; recover iter
    loop l1
; } end loop
ex:
    add esp, 5      ; free stack
    ret

printSym:
    mov eax, 4
    mov ebx, 1
    mov ecx, sym
    mov edx, sym_len
    int 0x80
    ret

printNum2:
    add edi, dword '0'
    push edi

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    pop edi
    ret

section .data
    num     dw 9999     ; our number/integer

    sym     dw "+"
    sym_len equ $ - sym