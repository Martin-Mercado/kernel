;punto de entrada para el SO
global  start

section .text
bits 32 ;porque todavia esta en modo 32 bits
start:
    mov esp, stack_top

    call check_multiboot
    call check_cpuid
    call check_long_mode

    
    ;imprimir "ok"
    mov dword [0xb8000], 0x2f4b2f4f ;la memoria de video empiza en 0xb8000, 0x2f4b2f4f es OK

    ;freeze
    hlt

check_multiboot:
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret

.no_multiboot:
    mov al, "M"
    jmp error

check_cpuid:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    cmp eax, ecx
    je .no_cpuid
    ret

.no_cpuid:
    mov al, "C"
    jmp error

check_long_mode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb.no_long_mode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_long_mode

    ret

.no_long_mode:
    mov al, "L"
    jmp error

error:
    ;texto de mensaje de error
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte [0xb800a], al
    hlt



;stack creation

section .bss
stack_bottom: resb 4069 * 4
stack_top: