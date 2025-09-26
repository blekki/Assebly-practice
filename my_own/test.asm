section .text   
    global _start

_start:
    sub esp, 8
    mov ecx, 1
    mov dword [esp + 4], ecx    ; iter
    mov dword [esp    ], 123456789    ; our value
    
    ; work version
    ; mov eax, 1234
    ; mov ebx, 10
    ; div ebx
    ; mov [esp], edx
    ; call printNum

    ; second work version
    ; sub esp, 1
    ; mov [esp], byte 9
    ; call printNum
    ; add esp, 1

    ; ; exit
    ; add esp, 8
    ; mov eax, 1
    ; int 0x80
    
    ; mov ecx, 6
; { start l1
l1: 
    mov [esp + 4], ecx    ; save iter
    mov eax, [esp]

    cmp eax, 0  ; todo: num --> eax
    ja a
    jmp exit
a:  
    inc dword [esp + 4]     ; add additional iteration
    
    ; eax % 10
    xor edx, edx    ; clear edx
    mov ebx, 10
    div ebx
    mov [esp], eax
    ; mov num, eax

    ; <--- ##### somewhere here contains error ####
    
    mov edi, edx
    call printNum2
    ; call printSym

    ; print result
    ; add esp, 4
    ; mov [esp], edx
    ; call printNum
    ; sub esp, 4
    ; mov ecx, esi
    mov ecx, [esp + 4]
    loop l1
exit:
; } l1 end
    
    add esp, 8      ; free stack
    mov eax, 1      ; exit
    int 0x80

printSym:
    mov eax, 4
    mov ebx, 1
    mov ecx, sym
    mov edx, sym_len
    int 0x80
    ret

; ---------- (right now is useless) ----------
; printNum:
;     pop edi
;     add [esp], dword '0'  ; anyway esp spents 4 bytes 

;     mov eax, 4
;     mov ebx, 1
;     mov ecx, esp
;     mov edx, 1
;     int 0x80

;     push edi
;     ret

printNum2:
    add edi, dword '0'
    push edi

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    pop edi
    ret

section .data
    num     dw 9999     ; our number/integer

    sym     dw "+"
    sym_len equ $ - sym