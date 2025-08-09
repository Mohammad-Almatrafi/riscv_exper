MEMORY 
{
    IM  : ORIGIN = 0x00000000, LENGTH = 128
    DM  : ORIGIN = 0x00000000, LENGTH = 128
}

SECTIONS
{
    .text : {
        *(.text*)
    } > IM
    .data : {
        *(.data*)
    } > DM
}


