; ### including extern functions/procedures ###
extern printPrimeNum
extern printLF

; ##### constants #####
WIDTH equ (10 + 2) ; two bytes for the feed line
HEIGHT equ 10

BORDER equ '#'
SPACE  equ ' '

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

; print line as border
printHat:
    ; fill line as border but without last two bytes
    mov ecx, (WIDTH - 2)
l_hat:
    dec ecx     ; need to dec ecx, because loop can't process index as 0
    mov [line + ecx], byte BORDER
    inc ecx     ; return state
    loop l_hat

    call addFL
    call print
    ret

; print envelope centre
printCentre:
    sub esp, 6
    mov [esp + 4], word 0 ; current dot position
       ;[esp + 2], word 0 ; dot offset
       ;[esp    ], word 0 ; iter


    ; clear line (borders is kept after printHat)
    mov ecx, (WIDTH - 4)
l1_centre:
    mov [line + ecx], byte SPACE
    loop l1_centre
; l1_centre end

    ; left and right borders
    ; mov [line + 0], byte '+'
    ; mov [line + (WIDTH - 3)], byte '+'

    ; dot pos
    xor edx, edx
    mov eax, (WIDTH - 2)
    mov ebx, HEIGHT
    div ebx
    ; sub ax, word 1  ; position into indexes standart: from 0 to (WIDTH - 1)
    mov [esp + 2], ax

    ; ; lines count in centre
    ; mov eax, (HEIGHT - 2)   ; height without hats
    ; mov ebx, 2
    ; div ebx
    ; xor ecx, ecx
    ; mov cx, ax   ; height without hats

    mov ecx, (HEIGHT - 2)
l2_centre:
    mov [esp], cx       ; save iter

    ; next dot pos
    xor eax, eax
    mov ax, [esp + 2]
    add [esp + 4], ax

    
    ; write dots in line
    mov ax, [esp + 4]       ; get dot front pos
    mov [line + eax], byte BORDER
    ; -
    mov ebx, (WIDTH - 3)    ; get dot back pos
    sub ebx, eax            ;
    mov [line + ebx], byte BORDER

    ; print line
    call print

    ; clear dots after printing
    mov ax, [esp + 4]       ; get dot front pos
    mov [line + eax], byte SPACE
    ; -
    mov ebx, (WIDTH - 3)    ; get dot back pos
    sub ebx, eax            ;
    mov [line + ebx], byte SPACE
    
    xor ecx, ecx        ; clear register
    mov cx, [esp]       ; recover iter
    loop l2_centre
; l2_centre end

    add esp, 6
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