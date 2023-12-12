;punto de entrada para el SO
global  start
extern long_mode_start

section .text
bits 32 ;porque todavia esta en modo 32 bits
start:
    mov esp, stack_top

    call check_multiboot
    call check_cpuid
    call check_long_mode

    ;tablas del stack (direcciones de memoria virtuales)
    call setup_page_tables

    call enable_paging

    ;cargar la descriptor table
    lgdt [gdt64.pointer]

    jmp gdt64.code_segment:long_mode_start

   

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

;LONG MODE NO ES LO MISMO QUE 64BITS
check_long_mode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_long_mode

    ret

.no_long_mode:
    mov al, "L"
    jmp error


setup_page_tables:
    mov eax, page_table_l3
    or eax, 0b11 
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11 
    mov [page_table_l3], eax

    mov ecx, 0 ;contador

.loop:

    mov eax, 0x200000
    mul ecx
    or eax, 0b10000011
    mov [page_table_l2 + ecx *8], eax

    inc ecx ;contador + 1
    cmp ecx, 512 ;verificar si toda la tabla esta mappeada
    jne .loop 

    ret

enable_paging:
    ;darle la ubicacion de memoria al procesador
    mov eax, page_table_l4
    mov cr3, eax

    ;permitir PAE (physical address extention) para que se pueda hacer el paging con 64 bits
    mov eax, cr4 
    or eax, 1 << 5
    mov cr4, eax

    ;permitir Long Mode (64bits)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ;permitir paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

error:
    ;texto de mensaje de error
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte [0xb800a], al
    hlt



;stack creation

;tablas
section .bss
align 4096

page_table_l4:
 resb 4096

page_table_l3:
 resb 4096

page_table_l2:
 resb 4096

;no se nesecita tabla l1

stack_bottom: resb 4069 * 4
stack_top:

;global descriptor table (no es del todo necesario porque se esta usando el paging, pero necesario para entrar en 64bits)

section .rodata ; read only data
gdt64:
    dq 0 
.code_segment: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)

.pointer:
    dw $ - gdt64 - 1
    dq gdt64