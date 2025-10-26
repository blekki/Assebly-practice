; ### including extern functions/procedures ###
extern printPrimeNum
extern printLF

; ##### constants #####
WIDTH equ (36 + 2) ; two bytes for the feed line
HEIGHT equ 18

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
    call bufferInit
    call printHat
    call printCentre
    call printHat
    ret

; add feedLine
bufferInit:
    ; add ASCII CR
    mov eax, (WIDTH - 2)
    mov [line + eax], byte 13
    ; add ASCII LF
    mov eax, (WIDTH - 1)
    mov [line + eax], byte 10
    ret

; print line as border
printHat:
    ; fill line as border but without last two bytes
    mov ecx, (WIDTH - 2)
l_hat:
    dec ecx     ; need to dec ecx, because else loop finishes execution before 0 index is set
    mov [line + ecx], byte BORDER
    inc ecx     ; return previously state
    loop l_hat

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

    ; dot pos
    xor edx, edx
    mov eax, (WIDTH - 2)
    mov ebx, HEIGHT
    div ebx
    mov [esp + 2], ax

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

    call print  ; print line
    ; Ps: fn print dosn't change EAX and EBX registers

    ; clear dots after printing
    mov [line + eax], byte SPACE
    mov [line + ebx], byte SPACE
    
    xor ecx, ecx        ; clear register
    mov cx, [esp]       ; recover iter
    loop l2_centre
; l2_centre end

    add esp, 6
    ret

; print our line
print:
    push eax
    push ebx
    
    mov eax, 4
    mov ebx, 1
    mov ecx, line
    mov edx, WIDTH
    int 0x80

    pop ebx
    pop eax
    ret


section .bss
    line: resb WIDTH