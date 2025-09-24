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
    call    print                   ; print result of the last function 
    call    nextln

    ; addition functions
    mov eax, 20
    mov ebx, 17
    call above
    call nextln

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
    
    ; { addition test does stack work correct (can be turn on)
    ; mov     edi, eax
    ; call    print
    ; xor     edi, edi
    ; }

    ret

; push parameters with the basic registers
; above(byte num1, byte num2) -> void
above:
    cmp eax, ebx
    ja equal    
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_false
    mov     edx, mf_len
    int     0x80
    ret
equal:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_true
    mov     edx, mt_len
    int     0x80
    ret

; move to the next line
; nextln() -> void
nextln:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, newline_len
    int 0x80
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
    symbol dw '0'

    msg_false   dw "false"
    mf_len      equ $ - msg_false
    msg_true    dw "true"
    mt_len      equ $ - msg_true

    newline     dw 0x0A             ; '\n'
    newline_len equ $ - newline