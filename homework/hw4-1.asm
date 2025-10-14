; ### area of extern functions/procedures ###
extern printInt
extern printLF

; ### base ###
section .text
    global _start

_start:
    xor     eax, eax     ; clear register
    mov     ax,  word 10 ; our source number
    
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
    sub     esp, 10
    ;       [esp + 8], word 0   ; dx buffer
    ;       [esp + 6], word 0   ; ax buffer
    mov     [esp + 4], word 0   ; dx after mul
    mov     [esp + 2], word ax  ; ax after mul
    mov     [esp    ], cx       ; iter (num/cx)
    
    ; # If (ax > 1) --> find factorial
    ; # else find easier way
    cmp     ax, 1
    ja      continue
    jmp     l1_end
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
    mov     [esp + 8], dx
    mov     [esp + 6], ax

    ; # DX mul
    mov     ax, [esp + 4]   ; dx:--
    mov     bx, [esp]
    mul     bx

    ; calculate final result
    mov     dx, ax
    add     dx, [esp + 8]
    mov     ax, [esp + 6]
    ; relocate final result for the next iteration
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
    add     esp, 10
    ret