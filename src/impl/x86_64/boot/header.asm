section .multiboot_header
header_start:
    ;lo primero que se inicia no es el SO sino el bootloader, el bootloader localiza el SO y lo inicia.

    ;multiboot
    dd 0xe85250d6

    ;arquitectura
    dd 0 ;protected mode i386

    ;largo del header
    dd header_end - header_start

    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    dw 0
    dw 0
    dd 8
header_end: