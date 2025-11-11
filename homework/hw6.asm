; ### area of extern functions/procedures ###
extern printPrimeNum
extern printLF
extern printInt
extern printSym

; ### constants ###
ARRAY_LEN equ 100

; ### base ###
section .text
    global _start

_start:

    xor ebx, ebx
    xor ecx, ecx

    mov esi, source
    mov edi, destination
    mov bx, 2
    mov cx, 10
    call printArray
    ; call sort


    mov eax, 1
    int 0x80

; esi - source
; edi - drain
; cx - elem count
; bx - symbol size
sort:
    sub esp, 16
    mov [esp + 12], byte 0    ; start pos (l_2)
    mov [esp + 10], byte 0    ; current pos (l_1)
    ; mov [esp + 8], word 0xFF    ; min value
    ; mov [esp + 6], word 0xFF    ; min value pos
    mov [esp + 4], bx   ; elem size
    mov [esp + 2], cx   ; (iter l_2)
    mov [esp    ], cx   ; (iter l_1)/elem count

    mov ecx, 20 ; (len * char_size)
    cld
    rep movsb

; ### use algorithm to the everyone elem
    mov cx, [esp]
l_1:
    mov [esp], cx   ; save iter

    ; set current pos
    xor eax, eax
    mov ax, [esp + 10]
    mov [esp + 12], ax
    ; reset min value
    mov [esp + 8], word 0xFF

l_2:    ; ### swap elems
    mov [esp + 2], cx   ; save iter


    ; compare two values
    xor eax, eax
    xor ebx, ebx
    mov bx, [esp + 12]              ; current offset
    mov ax, [destination + ebx]     ; current value
    ; debug: print array
    ; call printPrimeNum

    cmp ax, [esp + 8]  ; if (A[i] > min) then nothing
    ja above
    ; save new min value
    mov [esp + 8], ax
    ; save new min value pos
    mov bx, [esp + 12]
    mov [esp + 6], bx
above:

    ; make another step (l_1)
    mov bx, [esp + 4]
    add [esp + 12], bx

    xor ebx, ebx
    xor ecx, ecx

    mov esi, source
    mov edi, destination
    mov bx, 2
    mov cx, 10
    ; call sort
    call printArray

    ; recover iter
    xor ecx, ecx
    mov cx, [esp + 2]
    loop l_2
; end loop


    ; swap two values
    xor eax, eax
    xor ebx, ebx
    ;
    mov ax, [esp + 10]  ; offset
    mov bx, [esp + 6]   ; offset min value
    ;
    mov cx, [destination + eax]
    mov dx, [destination + eax]
    mov [destination + eax], dx
    mov [destination + ebx], cx
    
    ; debug: print min value
    ; xor eax, eax
    ; mov ax, [esp + 8]
    ; call printPrimeNum
    call printLF

    ; make another step (l_1)
    mov bx, [esp + 4]
    add [esp + 10], bx

    ; recover iter
    xor ecx, ecx
    mov cx, [esp]
    dec cx
    jnz l_1
    ; loop l_1
; end loop

    add esp, 16
    ret



printArray:
    push ebx    ; # note: push for showing the immutability of a number
    push ecx
    sub esp, 16
    mov [esp + 12], esi      ; source
    mov [esp +  8], ebx      ; num size
    mov [esp +  4], dword 0  ; pos-offset (changeable)
    mov [esp     ], ecx      ; iter/len   (changeable)

l_3:
    mov [esp], ecx   ; save iter
    
    ; preparation
    mov eax, 0
    mov [buffer], eax       ; clear buffer
    mov esi, [esp + 12]     ; recover source
    mov edi, buffer         ; recover destination

    ; copy part of source
    add esi, [esp + 4]  ; begin point
    mov ecx, 2  ; size
    cld
    rep movsb   ; copy bytes

    ; print value
    mov esi, [buffer]
    call printInt

    ; update offset
    mov eax, [esp + 8]
    add [esp + 4], eax

    ; print tiny space between characters
    mov eax, ' '
    call printSym

    ; recover iter
    mov ecx, [esp]
    loop l_3
; loop end
    call printLF    ; final feedline

    ; free memory and recover values
    mov esi, [esp + 12]
    add esp, 16
    pop ecx
    pop ebx
    ret

section .bss
    destination: resb ARRAY_LEN
    buffer: resb 4

section .data
    source dw   9, 8, 7, 6, 5, 4, 3, 2, 1
    array_len equ $ - source