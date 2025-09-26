section .text   
    global _start

_start:
    sub esp, 8
    mov ecx, 1
    mov dword [esp + 4], ecx    ; iter
    mov dword [esp    ], 123456 ; our value
    
; { begin
l1: 
    mov [esp + 4], ecx      ; save iter
    mov eax, [esp]

    cmp eax, 0
    ja a
    jmp exit
a:  
    inc dword [esp + 4]     ; add additional iteration
    
    ; eax % 10
    xor edx, edx    ; clear edx
    mov ebx, 10
    div ebx
    mov [esp], eax  ; save new basic number
    
    ; print remainder from division
    mov edi, edx    
    call printNum2

    mov ecx, [esp + 4]
    loop l1
; } end
exit:
    add esp, 8      ; free stack
    mov eax, 1      ; exit
    int 0x80

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