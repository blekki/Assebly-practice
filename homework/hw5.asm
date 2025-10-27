; ### including extern functions/procedures ###
extern printPrimeNum
extern printLF

; ##### constants ##
; an envelope colors
BORDER  equ '#'
DOT     equ '#'
SPACE   equ ' '

; ### MAIN PROGRAM ###
section .text
    global _start

_start:
    mov ah, 36              ; width
    mov al, 18              ; heigth
    call    printEnvelope

    ; exit
    mov     eax, 1
    int     0x80

; ### Functions ###
printEnvelope:
    mov [width], ah
    mov [heigth], al
    
    call    bufferInit
    call    printHat
    call    printCentre
    call    printHat
    ret

; add feedLine
bufferInit:
    mov eax, [width]                ; max_line_index + 1
    mov     [line + eax], byte 13   ; add ASCII CR
    add eax, 1                      ; max_line_index + 2
    mov     [line + eax], byte 10   ; add ASCII LF
    ret

; print line as border
printHat:
    ; fill line as top/bottom border
    xor ecx, ecx
    mov cl, [width]
l_hat:
    ; Need to dec and after inc ecx,
    ; because else loop finishes execution one operation earlier,
    ; and then zero index isn't set
    dec     ecx
    mov     [line + ecx], byte BORDER
    inc     ecx
    loop    l_hat
; l_hat end
    call    print               ; print hat
    ret

; print envelope centre
printCentre:
    sub     esp, 3
    mov     [esp + 2], byte 0   ; current dot position
    ;       [esp + 1], byte 0   ; dot offset
    ;       [esp    ], byte 0   ; iter

    ; clear line (but keep borders after printHat)
    xor     ecx, ecx
    mov     cl, [width]
    sub     cl, 2
l1_centre:
    mov     [line + ecx], byte SPACE
    loop    l1_centre
; l1_centre loop

    ; get dot offset
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx
    mov     al, [width]
    mov     bl, [heigth]
    div     bl
    mov     [esp + 1], al   ; save dot offset

    ; print dots
    xor     ecx, ecx
    mov     cl, [heigth]
    sub     cl, 2
l2_centre:
    mov     byte [esp], cl  ; save iter

    ; next dot pos
    xor     eax, eax
    mov     al, [esp + 1]   ; take offset
    add     [esp + 2], al   ; add offset to the old pos
    
    ; write dots in line
    xor     eax, eax
    mov     al, [esp + 2]   ; get front dot pos
    mov     [line + eax], byte DOT
    
    xor     ebx, ebx
    mov     bl, [width]
    dec     bl
    sub     bl, al          ; get back dot pos
    mov     [line + ebx], byte DOT

    call    print           ; print line
    
    ; Clear dots after printing line.
    ; Fn "print" didn't change EAX and EBX registers values
    mov     [line + eax], byte SPACE
    mov     [line + ebx], byte SPACE
    
    xor     ecx, ecx        ; clear register
    mov     cl, byte [esp]  ; recover iter
    loop    l2_centre
; end loop
    add     esp, 3
    ret

; print our line
print:
    push    eax
    push    ebx
    
    xor     edx, edx
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, line
    mov     dl, [width]
    add     dl, 2
    int     0x80

    pop     ebx
    pop     eax
    ret

section .bss
    line:   resb 255 + 2    ; two bytes for CR and FL
    heigth: resb 1
    width:  resb 1