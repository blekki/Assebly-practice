; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### program section #####
section .text   
    global _start

_start:
    mov [buffer_ptr], byte 0    ; init buffer busy bytes (0)
    
    mov eax, 12345678     ; our value/parameter
    ; todo: where to save???
    call intToStr       ; call convertor

    ; exit
    mov eax, 1
    int 0x80


intToStr:
    xor ecx, ecx    ; clear the ecx register
    mov cl, 1
    sub esp, 5
    ; todo: save number length
    mov byte  [esp + 4], cl    ; iter
    mov dword [esp    ], eax    ; our parameter
    
; { start loop
l1: 
    mov [esp + 4], byte cl      ; save iter
    mov eax, [esp]              ; get current value

    cmp eax, 0
    ja a
    jmp l1_ex
a:  
    inc byte [esp + 4]          ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esp], eax              ; save new value
    
    ; save int as char[n]
    mov eax, BUFFER_MAX_LEN
    sub eax, 1
    sub eax, [buffer_ptr]
    add dl, byte '0'
    mov [buffer + eax], dl
    inc byte [buffer_ptr]

    xor ecx, ecx
    mov cl, byte [esp + 4]      ; recover iter
    loop l1
; } end loop
l1_ex:
    exit:

    ; print result
    mov ecx, buffer
    mov edx, buffer_ptr
    call printWord

    ; exit
    add esp, 5      ; free stack
    ret

printWord:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

printSym:
    mov eax, 4
    mov ebx, 1
    mov ecx, sym
    mov edx, sym_len
    int 0x80
    ret

printNum:
    add edi, dword '0'
    push edi

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    pop edi
    ret

; ##### data section #####

section .data
    num     dw 9999     ; our number/integer

    sym     dw "+"
    sym_len equ $ - sym

    msg_ok       dw  "That's primal number", 0
    msg_ok_len   equ $ - msg_ok
    
section .bss
    buffer: resb BUFFER_MAX_LEN
    buffer_ptr: resb 1  ; save position the same way as esp: add --> free space