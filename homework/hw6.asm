; ### area of extern functions/procedures ###
extern printPrimeNum
extern printLF
extern printInt
extern printSym

; ### constants ###
; ARRAY_LEN equ 100

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
    call printArray     ; print unsorted data
    call sort           ; sort
    mov esi, edi
    call printArray     ; print sorted data

    mov eax, 1
    int 0x80

; esi - source
; edi - drain
; cx - elem count
; bx - symbol size
sort:
    push bx
    push cx
    sub esp, 12
    mov [esp + 10], word 0    ; min value address (offset)
    mov [esp +  8], word 0    ; offset (l_2)
    mov [esp +  6], word 0    ; offset (l_1)
    mov [esp +  4], cx   ; (iter l_2)
    mov [esp +  2], cx   ; (iter l_1)
    mov [esp     ], bx   ; elem size

    ; copy source into destination
    push esi    ; save origin addresses
    push edi
    mov ecx, source_byte_len
    cld
    rep movsb   ; copy esi into edi
    pop edi     ; recover addresses
    pop esi

; ### use algorithm to the everyone elem
    mov cx, [esp + 2]
l_1:
    mov [esp + 2], cx   ; save iter

    ; set l_2 offset
    mov ax, [esp + 6]
    mov [esp + 8], ax
    ; reset min value address
    mov [esp + 10], ax

; ### find minimum
    mov cx, [esp + 2]   ; start with (l_1) iter value
l_2:
    mov [esp + 4], cx   ; save iter


    ; compare two values (current and min)    ; todo: compare 2,4,8 bytes value
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    ; num A (current)
    mov cx, [esp + 8]
    mov ax, [destination + ecx]
    ; num B (last min)
    mov dx, [esp + 10]
    mov bx, [destination + edx]

    ; ; debug: print min value
    ; push ax
    ; push bx
    ; call printPrimeNum
    ; call printLF
    ; pop bx
    ; pop ax

    cmp ax, bx  ; if (A[i] < min) save new min value
    ja cont    ; if above -> do nothing
    mov ax, [esp + 8]   ; get current pos
    mov [esp + 10], ax  ; save min value pos in dest
cont:
    ; next elem address offset (l_2)
    mov ax, [esp]
    add [esp + 8], ax
    ; recover iter
    xor ecx, ecx
    mov cx, [esp + 4]
    loop l_2
; end loop (l_2)

    ; swap
    xor edx, edx
    mov dx, [esp + 10]
    mov ax, [destination + edx] ; save min (min -> A)
    mov dx, [esp + 6]
    mov bx, [destination + edx] ; save cur (cur -> B)
    ;
    mov dx, [esp + 10]
    mov [destination + edx], bx ; B -> min
    mov dx, [esp + 6]
    mov [destination + edx], ax ; A -> cur

    ; ; debug: print dest
    ; push esi
    ; mov esi, destination
    ; mov bx, 2
    ; mov cx, 10
    ; call printArray
    ; pop esi

    ; next elem address offset (l_1)
    mov ax, [esp]
    add [esp + 6], ax
    ; recover iter
    xor ecx, ecx
    mov cx, [esp + 2]
    dec cx
    jnz l_1
; end loop (l_1)

    ; final actions
    add esp, 12
    xor ecx, ecx
    xor ebx, ebx
    pop cx
    pop bx
    ret

printArray: ; fn printArray(source: esi) -> void
    push esi    ; # note: <push> for showing the immutability of a number
    push edi
    push ebx
    push ecx
    sub esp, 12
    mov [esp + 8], esi      ; source
    mov [esp + 4], ebx      ; num size (in bytes)
    mov [esp    ], ecx      ; iter/len   (changeable)
    
l_3:
    mov [esp], ecx   ; save iter
    
    ; prepare buffer
    mov dword [buffer], 0   ; clear buffer
    mov edi, buffer         ; recover destination

    ; copy part of source
    mov ecx, [esp + 4]  ; how much bytes need to copy
    cld
    rep movsb           ; copy bytes
    
    ; print value
    mov [esp + 8], esi      ; save esi
    mov esi, [buffer]       ; move edi into esi
    call printInt
    mov esi, [esp + 8]      ; recover esi

    ; print tiny space between characters
    mov eax, ' '
    call printSym

    ; recover iter
    mov ecx, [esp]
    loop l_3
; loop end
    call printLF    ; print feedline

    ; free memory and recover values
    add esp, 12
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

section .bss
    destination: resb source_byte_len
    buffer: resb 4

section .data
    source dw   9, 1880, 7, 66, 5, 44, 3, 2, 0, 1
    ; source dw   9, 8, 7, 6, 5, 4, 3, 2, 0, 1
    ; source dw   0, 2, 3, 2, 7, 9, 4, 2, 8, 1
    source_byte_len equ $ - source