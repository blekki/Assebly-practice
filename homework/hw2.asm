; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### program section #####
section .text   
    global _start

_start:
    mov [num_len], byte 0
    
    ; todo: where to save???

    mov eax, 123456     ; our value/parameter
    call intToStr       ; call convertor

exit:
    ; print result
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [num_len]
    int 0x80
    
    mov eax, 1
    int 0x80

intToStr:
    cmp eax, 0
    jne continue
    mov [buffer], byte '0'
    inc byte [num_len]
    jmp exit
continue:
    xor ecx, ecx    ; clear the ecx register
    mov cl, 1
    sub esp, 15
    mov byte  [esp + 14], cl     ; iter
    mov dword [esp + 10], eax    ; our parameter
    ;   byte  [esp     ]         ; our converted value
    
l1: ; { start loop
    mov [esp + 14], byte cl      ; save iter
    mov eax, [esp + 10]              ; get current value

    cmp eax, 0
    ja a
    jmp l1_ex
a:  
    inc byte [esp + 14]          ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esp + 10], eax              ; save new value

    add dl, byte '0'    ; convert into ascii
    
    ; save in stack converted value
    mov eax, [num_len]
    mov [esp + eax], byte dl
    inc byte [num_len]

    
    xor ecx, ecx
    mov cl, byte [esp + 14]      ; recover iter
    loop l1
l1_ex:  ; } end loop

    ; save in buffer
    mov cl, [num_len]
l2:
    mov [esp + 14], byte cl      ; save iter

    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov al, cl      ; last pos
    dec al

    mov bl, [num_len]
    dec bl
    sub bl, al
    xor ecx, ecx
    mov cl, byte [esp + ebx]    ; get symbol

    mov [buffer + eax], byte cl ; save symbol in buffer

    xor ecx, ecx
    mov cl, byte [esp + 14]      ; load iter
    loop l2
l2_ex:
    add esp, 15      ; free stack
    ret

; ##### other functions #####
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
    
section .bss
    buffer: resb BUFFER_MAX_LEN
    num_len: resb 1