; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### base section #####
section .text
    global intToStr

intToStr:
    ; esi = source
    mov     [num_len], byte 0

    ; prepare destinations
    mov     ecx, BUFFER_MAX_LEN     ; how much times repeat
    mov     edi, buffer             ; buffer address
    mov     al, 0                   ; value
    rep     stosb                   ; store values
    mov     edi, buffer             ; get fresh buffer

    ; check does (esi != 0)
    cmp     esi, 0
    jne     continue
    mov     [edi], byte '0'
    inc     byte [num_len]
    jmp     load_result
continue:
    xor     ecx, ecx                ; clear the ecx register
    mov     cl,  1
    sub     esp, 15
    mov     byte  [esp + 14], cl    ; iter
    mov     dword [esp + 10], esi   ; our parameter
    ;       byte  [esp     ]        ; our converted value
    
l1: ; { 
    mov     [esp + 14], byte cl     ; save iter
    mov     eax, [esp + 10]         ; get current value

    cmp     eax, 0
    ja      a
    jmp     l1_ex
a:  
    inc     byte [esp + 14]         ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor     edx, edx
    mov     ebx, 10
    div     ebx
    mov     [esp + 10], eax         ; save modified basic num (eax part)
    add     dl, byte '0'            ; convert num into ascii  (edx part)
    
    ; save in stack converted value
    mov     eax, [num_len]
    mov     [esp + eax], byte dl
    inc     byte [num_len]

    
    xor     ecx, ecx
    mov     cl, byte [esp + 14]     ; recover iter
    loop    l1
l1_ex: ; }
    
    ; replace converted from a stack to the buffer
    mov     cl, [num_len]
l2:
    mov     [esp + 14], byte cl     ; save iter

    ; clear registers
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx

    ; get stack elem address from back
    mov     al, cl
    dec     al

    ; get buffer elem address from front
    mov     bl, [num_len]
    dec     bl
    sub     bl, al
    xor     ecx, ecx
    mov     cl, byte [esp + ebx]    ; get symbol
    mov     [edi + eax], byte cl    ; save symbol in buffer

    xor     ecx, ecx                ; clear ecx register after operations
    mov     cl, byte [esp + 14]     ; load iter
    loop    l2
l2_ex:
    add     esp, 15                 ; free stack
    call load_result
    ; call print_res
    ret

load_result:
    mov edi, buffer
    mov edx, num_len
    ret

; ##### data section #####
section .bss
    buffer:  resb BUFFER_MAX_LEN    ; our place for saving results
    num_len: resb 1     ; intToString convertor variable