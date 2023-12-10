;punto de entrada para el SO
global  start

section .text
bits 32 ;porque todavia esta en modo 32 bits
start:
    ;imprimir "ok"
    mov dword [0xb8000], 0x2f4b2f4f ;la memoria de video empiza en 0xb8000, 0x2f4b2f4f es OK

    ;freeze
    hlt