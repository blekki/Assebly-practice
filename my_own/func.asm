section .text
    global _start

_start:
    ; stack operations
    sub     esp, 12                 ; full reserve
            ;    [esp + 8]          ; reserve for results
    mov     byte [esp + 4], 5       ; num 2
    mov     byte [esp    ], 4       ; num 1
    
    call    sum
    mov     edi, [esp + 8]          ; parameter for the next function
    add     esp, 12                 ; free stack
    
    call    print

    ; exit
    mov     eax, 1
    int     0x80

; push parameters with stack
; sum(byte num1, byte num2) -> byte result
sum:
    pop     ecx

    mov     eax, [esp    ]    ; num 1
    mov     ebx, [esp + 4]    ; num 2
    add     eax, ebx          ; sum
    mov     [esp + 8], eax    ; save result
    
    push    ecx

    ; { addition test does stack work correct
    mov     edi, eax
    call    print
    xor     edi, edi
    ; }

    ret

; push parameters with edi register
; print(byte symbol) -> void
print:
    add     edi, '0'        ; convert into ascii symbol
    mov     [symbol], edi

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, symbol
    mov     edx, 1
    int     0x80
    ret

section .data
    symbol db '0'