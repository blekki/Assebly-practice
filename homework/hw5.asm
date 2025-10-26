; ### including extern functions/procedures ###
extern printPrimeNum
extern printLF

; ##### constants #####
WIDTH equ (10 + 2) ; two bytes for the feed line
HIGTH equ 10

; ### main program ###
section .text
    global _start

_start:
    call printEnvelope
    ; exit
    mov eax, 1
    int 0x80

printEnvelope:
    call printHat

    call printCentre
    ; print envelope centre

    call printHat
    ret

; fill full line as border
printHat:
    mov ecx, (WIDTH - 2)
l_hat:
    mov [line + ecx], byte '+'
    loop l_hat

    call addFL
    call print
    ret

printCentre:
    sub esp, 4
    ;   [esp + 2] ; dot position
    ;   [esp    ] ; iter


    ; clear line
    mov ecx, (WIDTH - 2)
l_centre:
    mov [line + ecx], byte '.'
    loop l_centre

    ; ; find envelop center
    ; xor edx, edx
    ; mov eax, (WIDTH - 2)
    ; mov ebx, 2
    ; div ebx
    ; mov [esp], ax


    ; dot pos
    xor edx, edx
    mov eax, (WIDTH - 2)
    mov ebx, HIGTH
    div ebx
    mov [esp + 2], ax

    xor eax, eax
    mov ax, [esp + 2]
    mov [line + eax], byte '#'
    mov ax, (WIDTH - 2)
    sub ax, [esp + 2]
    mov [line + eax], byte '#'
    
;     ; fill center
;     xor ecx, ecx
;     mov cx, [esp]
; l_centre:
;     mov [esp], cx       ; save iter
    
;     cmp cx, [esp + 2]
;     je pushDot
;     mov [line + ecx], byte '.'
; pushDot:
;     mov [line + ecx], byte '#'

;     xor ecx, ecx
;     mov cx, [esp]  ; recover iter
;     loop l_centre
; ; end loop

    call addFL
    call print

    add esp, 4
    ret

; add sign to ride next line
addFL:
    mov eax, (WIDTH - 2)
    mov [line + eax], byte 13

    mov eax, (WIDTH - 1)
    mov [line + eax], byte 10
    ret

; print our line
print:
    mov eax, 4
    mov ebx, 1
    mov ecx, line
    mov edx, WIDTH
    int 0x80
    ret


section .bss
    line: resb WIDTH