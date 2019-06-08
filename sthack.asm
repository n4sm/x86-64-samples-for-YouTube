BITS 64

section .data
    n db `\n`

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp+8] ; Nom de l'éxécutable
    mov rdx, 0x8
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, n 
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp+16] ; path of the program
    mov rdx, 0x8
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, n ; \n
    mov rdx, 1
    syscall
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall