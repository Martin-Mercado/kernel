
#include "/home/super/Documents/CKernel/src/intf/print.h"

void kernel_main()
{
    print_clear();
    print_set_color(PRINT_COLOR_YELLOW, PRINT_COLOR_BLACK);
    print_str("ESTE ES UN KERNEL DE 64bits");
}