/*linker script*/

ENTRY(start) /*especificar el punto de entrada*/

SECTIONS /* esta parte se usa para especificar el layout de la memoria*/
{
    . = 1M; /*comenzar desde 1 megabyte*/

    .boot :
    {
        KEEP(*(.multiboot_header)) /*KEEP prohibe que se remuevan los datos de adentro*/
    }

    .text :
    {
        *(.text)
    }
}