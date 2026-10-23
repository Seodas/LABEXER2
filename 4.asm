section .data
    test_case dd 6

    number dw 0
    binary times 17 db 0

section .text
    global _start

_start:
    mov eax, [test_case]

    cmp eax, 1
    je case1
    cmp eax, 2
    je case2
    cmp eax, 3
    je case3
    cmp eax, 4
    je case4
    cmp eax, 5
    je case5
    cmp eax, 6
    je case6
    jmp exit_program

case1:
    mov word [number], 5
    jmp convert

case2:
    mov word [number], 10
    jmp convert

case3:
    mov word [number], 15
    jmp convert

case4:
    mov word [number], 8
    jmp convert

case5:
    mov word [number], 25
    jmp convert

case6:
    mov word [number], 42
    jmp convert

convert:
    movzx eax, word [number]
    mov ebx, 2
    xor ecx, ecx

divide_loop:
    xor edx, edx
    div ebx

    push edx
    inc ecx

    test eax, eax
    jnz divide_loop

    mov esi, ecx
    xor edi, edi

build_binary:
    pop edx
    add dl, '0'
    mov [binary + edi], dl
    inc edi

    loop build_binary

    mov byte [binary + edi], 10
    inc edi

    mov eax, 4
    mov ebx, 1
    mov ecx, binary
    mov edx, edi
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80