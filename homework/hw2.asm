; ##### constants section #####
BUFFER_MAX_LEN equ 10

; ##### program section #####
section .text   
    global _start

_start:
    mov [buffer_ptr], byte 0   ; init buffer busy bytes (0)
    mov [num_len], byte 0
    
    ; todo: where to save???

    mov eax, 1234567890     ; our value/parameter
    call intToStr       ; call convertor
    

    ; exit
    mov eax, 1
    int 0x80

intToStr:
    xor ecx, ecx    ; clear the ecx register
    mov cl, 1
    sub esp, 15
    mov byte  [esp + 14], cl     ; iter
    mov dword [esp + 10], eax    ; our parameter
    ;   byte  [esp     ]         ; our converted value
    
l1: ; { start loop
    mov [esp + 14], byte cl      ; save iter
    mov eax, [esp + 10]              ; get current value

    cmp eax, 0
    ja a
    jmp l1_ex
a:  
    inc byte [esp + 14]          ; add additional iteration
    
    ; (eax % 10) = (edx:eax)
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esp + 10], eax              ; save new value

    ; debug
    ; mov edi, edx
    ; call printNum

    add dl, byte '0'
    
    ; ### save int as char[n].
; other way make it
    mov eax, [num_len]
    ; mov eax, BUFFER_MAX_LEN     ; write from end
    ; sub eax, 1
    ; sub eax, [num_len]
    mov [esp + eax], byte dl
    inc byte [num_len]

    ; mov eax, [num_len]
    ; call printNum2

    ;
    ; debug: print [esp + eax]
    ; xor ebx, ebx
    ; mov bl, byte [esp + eax]
    ; xor eax, eax
    ; mov al, dl
    ; sub al, '0'
    ; call printNum2
    
    
    xor ecx, ecx
    mov cl, byte [esp + 14]      ; recover iter
    loop l1
l1_ex:  ; } end loop


    mov cl, [num_len]
l2:
    mov [esp + 14], byte cl      ; save iter

    xor eax, eax
    xor ebx, ebx
    xor edx, edx

    mov al, cl      ; last pos
    sub al, 1

    mov bl, [num_len]
    sub bl, 1
    sub bl, al
    xor ecx, ecx
    mov cl, byte [esp + ebx]    ; get symbol

    mov [buffer + eax], byte cl

    ;
    ; mov al, [buffer + eax]
    ; sub al, '0'
    ; call printNum2

    xor ecx, ecx
    mov cl, byte [esp + 14]      ; load iter
    loop l2
l2_ex:
;     ; print result
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [num_len]
    int 0x80

    add esp, 15      ; free stack
    ret

; ##### other functions #####
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

printNum2:
    add eax, dword '0'
    push eax

    mov eax, 4
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80

    pop eax
    ret
; ##### data section #####

section .data
    num     dw 9999     ; our number/integer
    
section .bss
    buffer: resb BUFFER_MAX_LEN
    buffer_ptr: resb 1  ; save position the same way as esp: add --> free space
    num_len: resb 1