.section .data
    buffer:
        .fill 256, 1, 0
    filename:
        .asciz "practice7.txt"
    message:
        .asciz "hello world\n"

.section .text
    .global _start

_start:
    //get current directory
    ldr x0, =buffer //load buffer from memory
    mov x1, 256 //buffer size
    mov x8, #17 //getcwd
    svc #0 //invoke syscal

    //print the directory
    mov x0, #1
    ldr x1, =buffer
    mov x2, 256
    mov x8, #64 //syscall for write
    svc #0

    //modify the program
    //open the file
    mov x0, #-100 //current directory
    ldr x1, =filename // load filename from memory
    mov x2, #0x401 //flags writeonly | create
    mov x3, #0777 //mode
    mov x8, #56 //syscall for open
    svc #0

    mov x9, x0

    //write to file
    mov x0, x9
    ldr x1, =message
    mov x2, #13 //size of the message
    mov x8, #64 //write
    svc #0

    //change permissions
    mov x0, #-100
    ldr x1, =filename
    mov x2, #0755 //chmod 755
    mov x3, #0
    mov x8, #53
    svc #0

    //close the file
    mov x0, x9
    mov x8, #57
    svc #0

    //exit
    mov x0, #1 //return status 1
    mov x8, #93 //exit
    svc #0
    
