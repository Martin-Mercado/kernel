global long_mode_start

section .text

bits 64
long_mode_start:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

     ;imprimir "ok"
    mov dword [0xb8000], 0x2f4b2f4f ;la memoria de video empiza en 0xb8000, 0x2f4b2f4f es OK

    hlt