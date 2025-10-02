; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### program section #####
section .text
    global _start

_start:
    ; if you want check your number, change EAX register value
    mov     eax, 17    ; <-- change here
    call printNum
    call isPrimal
    
    ; exit
    mov eax, 1
    int 0x80

isPrimal:
    ; reserve stack space
    add     esp, 12
    mov     dword [esp + 8], 1    ; iter count
    mov     dword [esp + 4], 2    ; save divisor
    mov     dword [esp    ], eax  ; save our number
    
    ; ### checking starts
    ; check does (num <= 2)
    mov     eax, [esp]
    cmp     eax, 2
    jbe     e1
    jmp     ex1
e1:
    call    printOk
    jmp     isPrimal_ex
ex1:

; loop begin
    xor ecx, ecx
    mov     ecx, [esp + 8]      ; recover iter
l1:
    mov     [esp + 8], ecx      ; save iter
    mov     ebx, [esp + 4]      ; load our divisor
    mov     eax, [esp]          ; load our value
    
    ; check does (ebx != num)
    cmp     eax, ebx
    jne     ne
    call    printOk
    jmp     isPrimal_ex
ne:
    ; divide
    xor     edx, edx            ; clear edx register
    div     ebx

    ; check does (num % ebx == 0)
    cmp     edx, 0
    je      e2
    ; else it tries again with other divisor
    inc     dword [esp + 8]     ; additional iter
    inc     dword [esp + 4]     ; next devisor
    jmp     ex2
e2:
    call    printFail
    jmp     isPrimal_ex
ex2:
    mov     ecx, [esp + 8]      ; recover iter
    loop    l1
; loop end

isPrimal_ex:
    sub     esp, 12             ; free stack
    ret

; ----------------------------------------
; ##### "print in sonsole" functions #####
printNum:
    mov     esi, eax
    xor     ecx, ecx
    mov     cl, 1
    add     esp, 16
    mov     [esp + 15], cl      ; iter    
    mov     [esp + 11], esi     ; number
    mov     [esp + 10], byte 0  ; char[].len
    ;       [esp     ]          ; char[] (as buffer)

    ; check does (source_value != 0)
    cmp     eax, 0
    jne     l2
    push    esi
    mov     esi, 0
    call    printSym
    pop     esi
    jmp     l3_ex
l2:
    mov     [esp + 15], byte cl     ; save iter
    mov     eax, [esp + 11]         ; load num
    
    ; check does (eax != 0)
    cmp     eax, 0
    ja      a
    jmp     l2_ex
a:
    inc     byte [esp + 15]

    ; (eax % 10) = (edx:eax)
    xor     edx, edx
    mov     ebx, 10
    div     ebx
    mov     [esp + 11], eax         ; save modified basic num (eax part)
    add     dl, byte '0'            ; convert num into ascii  (edx part)

    ; save number
    xor     eax, eax
    mov     al, byte [esp + 10]
    mov     [esp + eax], byte dl
    inc     byte [esp + 10]

    xor     ecx, ecx
    mov     cl, byte [esp + 15]     ; recover iter
    loop    l2
l2_ex:

    mov     cl, byte [esp + 10]
l3:
    mov     byte [esp + 15], cl

    ; clear registers
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx

    ; get stack elem address from back
    mov     al, cl
    dec     al
    mov     bl, byte [esp + eax]

    ; print symbol
    mov     eax, ebx
    sub     eax, '0'
    call    printSym
    
    xor     ecx, ecx
    mov     cl, byte [esp + 15]     ; recover iter
    loop    l3
l3_ex:
    call    printNewline
    sub     esp, 16                 ; clear stack
    mov     eax, esi
    ret
; ----------------------------------
printSym:
    add     eax, dword '0'
    push    eax

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, esp
    mov     edx, 1
    int     0x80

    pop     eax
    ret

printOk:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_ok
    mov     edx, msg_ok_len
    int     0x80
    call    printNewline
    ret

printFail:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_fail
    mov     edx, msg_fail_len
    int     0x80
    call    printNewline
    ret

printNewline:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, newline_len
    int     0x80
    ret
    

section .data
    msg_ok       dw  "That's prime number", 0
    msg_ok_len   equ $ - msg_ok
    msg_fail     dw  "That's NOT prime number"
    msg_fail_len equ $ - msg_fail
    
    newline      dw 0x0A     ; newline ascii code
    newline_len  equ $ - newline