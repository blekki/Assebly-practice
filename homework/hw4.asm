; ### area of extern functions/methods ###
extern printInt
extern printStr
extern printLF
extern printPrimeNum

; ### base ###
section .text
    global _start

_start:
    xor eax, eax            ; clear register
    mov ax, word 2          ; our source number
    ; !!! bug: if (ax = 1) res = 0
    
    ; print our value
    mov esi, eax
    call printInt
    call printLF
    mov eax, esi    ; recover value

    ; get factorial
    call factorial

    ; print result
    shl edx, 16
    or eax, edx
    mov esi, eax
    call printInt
    call printLF
    
    ; exit
    mov eax, 1
    int 0x80
    
factorial:  ; fn factorial(ax: source-value) -> dx:ax
    mov cx, ax
    add esp, 10
    ;   [esp + 8], word 0   ; dx buffer
    ;   [esp + 6], word 0   ; ax buffer
    mov [esp + 4], word 0   ; dx after mul
    mov [esp + 2], word ax  ; ax after mul
    mov [esp    ], cx       ; iter (num/cx)
    
    dec word [esp]
    
    ; todo: if [esp] == 0 --> exix
    
    xor ecx, ecx
    mov cx, word [esp]
l1:
    mov [esp], word cx       ; save iter
    ; preparation
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    mov [esp + 8], word 0
    mov [esp + 6], word 0

    ; # AX mul
    mov ax, [esp + 2]   ; --:ax
    mov bx, [esp]
    mul bx
    ; save pre-result
    add [esp + 8], dx
    add [esp + 6], ax

    ; # DX mul
    mov ax, [esp + 4]   ; dx:--
    mov bx, [esp]
    mul bx
    ; add pre-result
    add dx, [esp + 8]
    add ax, [esp + 6]

    ; save full pre-result for the next iteration
    mov [esp + 4], dx
    mov [esp + 2], ax

    ; --- error ---
    ; mov esi, [esp]
    ; call printInt
    ; call printLF
    ; mov [esp], word 1

    ; # work version
    ; mov eax, 0
    ; call printPrimeNum
    ; call printLF

    ; mov eax, 4
    ; mov ebx, 1
    ; mov ecx, say
    ; mov edx, say_len
    ; int 0x80

    ; mov eax, prime_say
    ; mov ebx, say_len
    ; call printPrimeNum


    ; mov eax, [esp]
    ; call printPrimeNum
    
    ; -------------

    xor ecx, ecx
    mov cx, word [esp]       ; recover iter
    loop l1
; l1_end:

    ; return result
    xor edx, edx
    xor eax, eax
    mov dx, word [esp + 4]
    mov ax, word [esp + 2]
    sub esp, 10
    ret

section .data
    say         dw '0'     ; newline ascii code
    prime_say   dw 9     ; newline ascii code
    say_len     equ $ - say