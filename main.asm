; [Assembleur] : 
;    mips - armv7 - x86 - x86-64 ou x64

; At&t : instruction $0x1, %eax
; Intel : instruction eax, 0x1

;   [Segment]
;       .bss = variables non initialisées : int a; == int a = 0, char buf[256];
;       .data = variables initialisées int a = 1;
;       .text = code executable : printf("%d", a);
;
;   [Registres]
;       ax -> Eax (Extended ax) -> rax
;       bx -> Ebx -> rbx
;       cx -> Ecx -> rcx
;       dx -> Edx -> rdx
;       si -> Esi -> rsi # src
;       di -> Edi -> rsi
;       sp -> Esp -> rsp
;       bp -> Ebp -> rbp
;       ip -> Eip -> rip
;
;   [Instructions]
;       mov : met une valeur dans un registre.
;       db  : déclare un byte (octet).
;       lea : met l'addresse d'une variable dans la destination. 


BITS 64

section .bss
    a resb 256

section .data
    hello db `hello world\n`
    hello_len equ $-hello 

section .text
    global _start ; l'EP ici

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, hello_len
    syscall
    mov rax, 123
    mov [a], rax
    mov rax, 60
    mov rdi, 0
    syscall


