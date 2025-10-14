; ### area of extern functions/procedures ###
extern printInt
extern printLF
extern printSym
extern printPrimeNum

; ### base ###
section .text
    global _start

_start:
    xor     eax, eax    ; clear register
    mov     ax,  word 11 ; our source number
    
    ; print our value
    mov     esi, eax
    call    printInt
    call    printLF
    mov     eax, esi    ; recover value

    ; get factorial
    call    factorial   ; fn factorial(ax: source-value) -> dx:ax

    ; glue results in one register (dx:ax --> eax)
    shl     edx, 16     ; 0x0000FFFF --> 0xFFFF0000
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
    mov dx, 0
    cmp ax, 1
    jna ne
    mov cx, ax
    dec cx      ; iter = ax - 1
    call factorial_rec  ; return (dx:ax)
ne:
    ret

factorial_rec:
    sub     esp, 10
    ;       [esp + 8], word 0   ; dx buffer
    ;       [esp + 6], word 0   ; ax buffer
    mov     [esp + 4], word dx   ; dx after mul
    mov     [esp + 2], word ax  ; ax after mul
    mov     [esp    ], cx       ; iter (num/cx)

    ; cleaning
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx
    
    cmp     [esp], word 0
    ja      next_iter
    ; return result
    mov     dx,  word [esp + 4]
    mov     ax,  word [esp + 2]
    jmp     finish
next_iter:

    ; # AX mul
    mov     ax, [esp + 2]   ; --:ax
    mov     bx, [esp]
    mul     bx
    ; save a pre-result
    mov     [esp + 8], dx
    mov     [esp + 6], ax
    
    ; # DX mul
    mov     ax, [esp + 4]   ; dx:--
    mov     bx, [esp]
    mul     bx
    ; add the pre-result for getting a full result

    ; final result
    mov dx, ax
    add dx, [esp + 8]
    mov ax, [esp + 6]

    ; !!! ---------------- !!!
    ; For future updates!
    ; After this msg, stop touch the AX, DX, CX registers
    ; These are the parameters for the next recursion iteration
    ; ------------------------
    
    ; load results
    ; mov     dx, [esp + 8]
    ; mov     ax, [esp + 6]

    ; add ax, dx
    ; mov dx, 0

    ; ps: potential place for free stack : will save much stack memory
    ; > sub     esp, 10

    mov     cx, word [esp]
    dec     cx
    call    factorial_rec
finish:
    add     esp, 10
    ret

; -----------------------------

; Приклад виклику:
; push word 5
; call countdown_rec
; add esp, 2 ; Очистити стек від параметра

countdown_rec:
    sub esp, 2
    mov [esp], word ax

    cmp     ax, 0
    je      fini
    mov     ax, word [esp]
    dec     ax
    call    countdown_rec
fini:
    add esp, 2
    ret