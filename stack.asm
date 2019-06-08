BITS 64
%define LEN 256 ; #define LEN 256

section .bss
    entry resb LEN ; char entry[256];

section .data
    prompt db 'Your name : ' ; + entrée de l'utilisateur (12)
    prompt_len equ $-prompt

    prnt_name db 'Your name is : '
    prnt_name_len equ $-prnt_name


section .text
    global _start

_start:
    jmp _prompt

_prompt:
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall
    jmp _read

_read:
    mov rax, 0x0
    mov rdi, 0x1
    mov rsi, entry
    mov rdx, LEN
    syscall
    push rsi
    jmp _prnt_name

_prnt_name:
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, prnt_name
    mov rdx, prnt_name_len
    syscall
    mov rax, 0x1
    mov rdi, 0x1
    pop rsi ; mov rsi, entry
    mov rdx, 0xC
    syscall
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall