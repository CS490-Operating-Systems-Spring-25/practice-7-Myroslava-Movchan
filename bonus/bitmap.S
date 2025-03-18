.section .data
    prompt:
        .asciz "enter your symbols (B, r, g, b, y, w, c, m): "
    
    buffer:
        .space 17                    // buffer for user input

    black:
        .asciz "\033[40m" //black
    red:
        .asciz "\033[41m" //red
    green:
        .asciz "\033[42m" //green
    yellow:
        .asciz "\033[43m" //yellow
    blue:
        .asciz "\033[44m" //blue
    magenta:
        .asciz "\033[45m" //magenta
    cyan:
        .asciz "\033[46m" //cyan
    white:
        .asciz "\033[47m" //white
    default:
        .asciz "\033[0m"  //default

    spaces:
        .asciz "  "

    newline:
        .asciz "\n"

.section .text
    .global _start

_start:
    mov x0, #1
    ldr x1, =prompt //load prompt from memory
    mov x2, #49 //length
    mov x8, #64 //write syscall
    svc #0

    // read user input 
    mov x0, #0
    ldr x1, =buffer
    mov x2, #16 //input length
    mov x8, #63 // syscall number for read
    svc #0
    mov x4, x0 // store number of characters read

    mov x3, #0

loop_char:
    cmp x3, x4  //compare index to number of characters read
    bge end     // if index >= number of characters then exit

    ldr x7, =buffer
    add x7, x7, x3  // address of current character
    ldrb w6, [x7]   // load current character (byte)

    cmp w6, #10  //compare character to newline
    beq end      // if newline then exit

    // check if the character is one of the valid color codes
    cmp w6, #'B'
    beq set_black
    cmp w6, #'r'
    beq set_red
    cmp w6, #'g'
    beq set_green
    cmp w6, #'y'
    beq set_yellow
    cmp w6, #'b'
    beq set_blue
    cmp w6, #'m'
    beq set_magenta
    cmp w6, #'c'
    beq set_cyan
    cmp w6, #'w'
    beq set_white

    b next_char

set_black:
    ldr x5, =black
    b print_cell
set_red:
    ldr x5, =red
    b print_cell
set_green:
    ldr x5, =green
    b print_cell
set_yellow:
    ldr x5, =yellow
    b print_cell
set_blue:
    ldr x5, =blue
    b print_cell
set_magenta:
    ldr x5, =magenta
    b print_cell
set_cyan:
    ldr x5, =cyan
    b print_cell
set_white:
    ldr x5, =white
    b print_cell

print_cell:
    // print colors
    mov x0, #1
    mov x1, x5  //pointer to escape code
    mov x2, #5
    mov x8, #64
    svc #0

    // print two spaces between cells
    mov x0, #1
    ldr x1, =spaces
    mov x2, #2
    mov x8, #64
    svc #0

    // print default color code
    mov x0, #1
    ldr x1, =default
    mov x2, #4
    mov x8, #64
    svc #0

next_char:
    add x3, x3, #1  // increment index
    b loop_char

end:
    // print newline at the end
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    // exit
    mov x0, #0
    mov x8, #93
    svc #0
