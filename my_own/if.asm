section .text
    global _start

_start:
    mov eax, 15     ; out value
    
    cmp eax, 10     ; comparison
    ja ok           ; condition
    mov ecx, bad    ; if false
    jmp exit
ok:
    mov ecx, fine   ; if true
exit:
    
    ; other code
    mov eax, 4
    mov ebx, 1
      ; ecx, msg
    mov edx, 4
    int 0x80

    ; exit
    mov eax, 1
    int 0x80

section .data
    bad  db "bad "
    fine db "fine"