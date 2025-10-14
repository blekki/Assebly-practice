; ### area of extern functions/procedures ###
extern printInt
extern printLF

; ### base ###
section .text
    global _start

_start:
    xor     eax, eax    ; clear register
    mov     ax,  word 5 ; our source number
    
    ; print our value
    mov     esi, eax
    call    printInt
    call    printLF
    mov     eax, esi    ; recover value

    ; get factorial
    call    factorial   ; fn factorial(ax: source-value) -> dx:ax

    ; glue result in one register (dx:ax --> eax)
    shl     edx, 16     ; 0x0000XXXX --> 0xXXXX0000
    or      eax, edx
    ; print result  
    mov     esi, eax
    call    printInt
    call    printLF
    
    ; exit
    mov     eax, 1
    int     0x80

; fn factorial(ax: source-value) -> dx:ax
factorial:
    mov     cx, ax
    add     esp, 10
    ;       [esp + 8], word 0   ; dx buffer
    ;       [esp + 6], word 0   ; ax buffer
    mov     [esp + 4], word 0   ; dx after mul
    mov     [esp + 2], word ax  ; ax after mul
    mov     [esp    ], cx       ; iter (num/cx)
    
    ; if (ax == 1) --> return 1
    cmp     ax, 1
    jne     continue
    mov     [esp + 2], word 1
    jmp     l1_end
    ; else find factorial  
continue:
    dec     word [esp]      ; multiplies always lower by 1 then factorial base

    xor     ecx, ecx
    mov     cx,  word [esp]
l1:
    mov     [esp], word cx  ; save iter
    ; preparation to the calculation
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx
    mov     [esp + 8], word 0
    mov     [esp + 6], word 0

    ; # AX mul
    mov     ax, [esp + 2]   ; --:ax
    mov     bx, [esp]
    mul     bx
    ; save pre-result
    add     [esp + 8], dx
    add     [esp + 6], ax

    ; # DX mul
    mov     ax, [esp + 4]   ; dx:--
    mov     bx, [esp]
    mul     bx
    ; add pre-result
    add     dx, [esp + 8]
    add     ax, [esp + 6]

    ; save full pre-result for the next iteration
    mov     [esp + 4], dx
    mov     [esp + 2], ax

    ; preparation to the next iter
    xor     ecx, ecx
    mov     cx,  word [esp] ; recover iter
    loop    l1
l1_end:
    ; return result
    xor     edx, edx
    xor     eax, eax
    mov     dx,  word [esp + 4]
    mov     ax,  word [esp + 2]
    sub     esp, 10
    ret