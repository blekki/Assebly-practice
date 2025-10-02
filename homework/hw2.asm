; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### program section #####
section .text   
    global _start

_start:
    mov [buffer_ptr], byte 0   ; init buffer busy bytes (0)
    
    mov eax, 12345678     ; our value/parameter
    ; todo: where to save???
    call intToStr       ; call convertor

    ; exit
    mov eax, 1
    int 0x80

intToStr:
    xor ecx, ecx    ; clear the ecx register
    mov cl, 1
    sub esp, 5
    mov byte  [esp + 4], cl     ; iter
    mov dword [esp    ], eax    ; our parameter
    
l1: ; { start loop
    mov [esp + 4], byte cl      ; save iter
    mov eax, [esp]              ; get current value

    cmp eax, 0
    ja a
    jmp l1_ex
a:  
    inc byte [esp + 4]          ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esp], eax              ; save new value
    
    ; ### save int as char[n].
    ; get right ptr offset (BUFFER_MAX_LEN - 1 - buffer_ptr)
    
    mov eax, BUFFER_MAX_LEN
    sub eax, 1
    sub eax, [buffer_ptr]

    mov eax, 9
    add dl, byte '0'            ; convert num into ascii symbol
    mov [buffer + eax], dl      ; save symbol
    inc byte [buffer_ptr]

    ; debug: print buffer
    ; mov edi, [buffer + eax]
    ; sub edi, '0'
    ; call printNum

    xor ecx, ecx
    mov cl, byte [esp + 4]      ; recover iter
    loop l1
l1_ex:  ; } end loop

    mov [buffer], byte 48       ; todo: remove
    mov [buffer + 1], byte 48   ; todo: remove

    ; print result
    ; mov eax, BUFFER_MAX_LEN
    ; sub eax, [buffer_ptr]
    ; lea ecx, [buffer + eax]
    ; mov edx, 8
    ; nice
    ; mov ecx, buffer
    ; mov edx, 8
    ; sub edx, 3
    
    ; mov eax, 2
    lea ecx, buffer
    mov edx, 8
    
    mov eax, 4
    mov ebx, 1
    int 0x80

    add esp, 5      ; free stack
    ret

; get_len:
;     ; eax -- buffer
;     mov ecx, 1
; l2:
    
;     push ecx
;     loop l2

printNum:
    add edi, dword '0'
    push edi

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    pop edi
    ret
; ##### data section #####

section .data
    num     dw 9999     ; our number/integer
    
section .bss
    buffer: resb BUFFER_MAX_LEN
    buffer_ptr: resb 1  ; save position the same way as esp: add --> free space