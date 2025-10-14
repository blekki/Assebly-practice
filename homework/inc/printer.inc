extern intToStr

section .text
    global printInt         ; print integer value
    global printStr         ; print string
    global printLF          ; print "\n" (get next line). LF = line feed
    global printPrimeNum    ; print prime number (auto convert num into char)

printInt:
    ; fn intToStr(esi) -> edi: string, edx: length
    call intToStr
    
    ; fn printStr(eax: string, ebx, length) -> void
    mov eax, edi
    mov ebx, edx
    call printStr

    ret

printStr:
    push eax

    mov     ecx, [esp]  ; string
    mov     edx, ebx    ; length
    mov     eax, 4
    mov     ebx, 1
    int     0x80
    
    pop eax
    ret

; print new line
printLF:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, newline_len
    int     0x80
    ret

printPrimeNum:
    add eax, '0'
    mov [prime_num], eax   ; save value in buffer
    mov eax, prime_num     ; get buffer ptr
    mov ebx, 1          ; set length
    call printStr
    ret


section .data
    newline      dw 0x0A     ; newline ascii code
    newline_len  equ $ - newline
    prime_num dw '0'