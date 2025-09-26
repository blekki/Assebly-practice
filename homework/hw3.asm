section .text
    global _start

_start:
    ; if you wan't check your number, change eax register value
    mov     eax, 239    ; <-- change here

    ; reserve stack space
    add     esp, 12
    mov     dword [esp + 8], 1    ; iter count
    mov     dword [esp + 4], 2    ; save divisor
    mov     dword [esp    ], eax  ; save our number
    
    ; ### checking started ###
    ; check does num <= 2
    mov     eax, [esp]
    cmp     eax, 2
    jbe     e1
    jmp     ex1
e1:
    call    print_ok
    jmp     exit
ex1:

; ### loop begin ###
    mov     ecx, [esp + 8]  ; recover iter
l1:
    mov     [esp + 8], ecx  ; save iter
    mov     ebx, [esp + 4]
    mov     eax, [esp]
    
    ; check does ebx != num
    cmp     eax, ebx
    jne     ne
    call    print_ok
    jmp     exit
ne:

    ; other operations
    xor     edx, edx    ; clear edx register
    div     ebx

    ; check does num % ebx == 0
    cmp     edx, 0
    je      e2
    inc     dword [esp + 8]     ; additional iter
    inc     dword [esp + 4]     ; next devisor
    jmp     ex2
e2:
    call    print_fail
    jmp     exit
ex2:
    mov     ecx, [esp + 8]      ; recover iter
    loop    l1
; ### loop end ###

exit:
    sub     esp, 12     ; free stack
    mov     eax, 1
    int     0x80

; ##### other functions #####

print_ok:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_ok
    mov     edx, msg_ok_len
    int     0x80
    call    print_newline
    ret

print_fail:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, msg_fail
    mov     edx, msg_fail_len
    int     0x80
    call    print_newline
    ret

print_newline:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, newline_len
    int     0x80
    ret

section .data
    msg_ok       dw  "That's primal number"
    msg_ok_len   equ $ - msg_ok
    msg_fail     dw  "That's NOT primal number"
    msg_fail_len equ $ - msg_fail
    
    newline      dw 0x0A     ; newline ascii code
    newline_len  equ $ - newline