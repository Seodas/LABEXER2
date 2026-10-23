section .data
    test_case dd 1

    balanced_msg db "ESP offset: 0 bytes (Balanced)", 10
    balanced_len equ $ - balanced_msg

    error_msg db "Stack error", 10
    error_len equ $ - error_msg

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
    jmp stack_error

case1:
    mov eax, 10
    mov ebx, 20
    mov ecx, 30
    mov edx, 40
    jmp run_subroutine

case2:
    mov eax, 5
    mov ebx, 5
    mov ecx, 10
    mov edx, 2
    jmp run_subroutine

case3:
    mov eax, 100
    mov ebx, 50
    mov ecx, 25
    mov edx, 5
    jmp run_subroutine

case4:
    mov eax, 1
    mov ebx, 2
    mov ecx, 3
    mov edx, 4
    jmp run_subroutine

case5:
    mov eax, 88
    mov ebx, 11
    mov ecx, 4
    mov edx, 2
    jmp run_subroutine

case6:
    mov eax, 0
    mov ebx, 15
    mov ecx, 15
    mov edx, 0
    jmp run_subroutine

run_subroutine:
    mov esi, esp
    call calculate_foo

    cmp esp, esi
    jne stack_error

    mov eax, 4
    mov ebx, 1
    mov ecx, balanced_msg
    mov edx, balanced_len
    int 0x80
    jmp exit_program

calculate_foo:
    ; Save all registers
    push eax
    push ebx
    push ecx
    push edx

    cmp dword [test_case], 1
    je operation1
    cmp dword [test_case], 2
    je operation2
    cmp dword [test_case], 3
    je operation3
    cmp dword [test_case], 4
    je operation4
    cmp dword [test_case], 5
    je operation5
    cmp dword [test_case], 6
    je operation6

operation1:
    ; Multiply/Add
    imul eax, ebx
    add eax, ecx
    jmp restore_registers

operation2:
    ; Division/Accumulation
    xor edx, edx
    div ebx
    add eax, ecx
    jmp restore_registers

operation3:
    ; Subtraction/Scaling
    sub eax, ebx
    imul eax, ecx
    jmp restore_registers

operation4:
    ; Bitwise AND/OR
    and eax, ebx
    or ecx, edx
    jmp restore_registers

operation5:
    ; Modulo and Division
    xor edx, edx
    div ebx
    mov eax, edx

    xor edx, edx
    div ecx
    jmp restore_registers

operation6:
    ; Zero-state arithmetic
    add eax, ebx
    sub eax, ecx
    add eax, edx
    jmp restore_registers

restore_registers:
    ; Restore in reverse order
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

stack_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80