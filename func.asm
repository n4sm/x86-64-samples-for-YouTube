;                                                   Les fonctions                                           
;
;   I - Les conventions d'appel
;       CDECL (Standard C Calling Convention) : 
;           Les arguments sont push sur la stack, et c'est l'appelant qui 'nettoie' la stack après le call
;
;       STDCALL (Standard Call):
;           Les arguments sont push sur la stack, c'est la fonction appelée qui clear la stack en donnant un argument à l'instruction ret
;
;       FASTCALL (Fast Calling Convention):
;           Les arguments sont mis dans rdi + rsi + rdx + rcx + r8 + r9 + xmm0 + xmm1 + xmm2 + xmm3 + xmm4 + xmm5 + xmm6 + xmm7 push sur la stack


; call <étiquette>: push rip && jmp étiquette
; ret 

;=================================================

; Credits Azales le s

BITS 64
%define LEN 256
;%include "fonction.asm"

section .data
    hello db 'Hello world', 0xa, 0x0
    hello_len equ $-hello

section .text
    global _start

_start:
    call check_rsp
    mov rax, [rsp+16]
    push hello
    mov rdi, rax
    call _atoi
    push rax
    call func_prnt_hello ; void prnt(int count, char *ptr);
    jmp _exit

func_prnt_hello:
    push rbp
    mov rbp, rsp
    mov r10, [rbp+16]
    xor rcx, rcx
    jmp _boucle

_boucle:
    cmp rcx, r10
    push rcx
    je _end_boucle
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, [rbp+24]
    mov rdx, hello_len
    syscall
    pop rcx
    inc rcx
    jmp _boucle

_end_boucle:
    jmp _ret

check_rsp:
    push rbp
    mov rbp, rsp
    cmp byte [rsp+16], 0x2
    je _Good_value
    jmp _exit

_Good_value:
    jmp _ret

_ret:
    leave ; mov rsp, rbp && pop rbp
    ret
_exit: 
    mov rax, 60
    mov rdi, 0x1
    syscall

;==================================================================

;Réimplémentation de la fonction int atoi(const char *nptr)
;Prototype : int atoi(const char *nptr);

;==================================================================


_atoi:
    push rbp
    mov rbp, rsp
    call check_string
    cmp rax, 0
    jne _ret
    call _strlen
    mov r11, rax ; mov de la len de la string
    sub r11, 1
    cmp r11, 0
    je _zero_pas_bo
    cmp r11, 1
    je _un_pa_bo_ossi
    cmp r11, 9
    jg _tro_gran
    mov rcx, 0
    mov rsi, rdi
    jmp _a_l

_a_l:
    cmp rcx, r11
    je _a
    cmp rcx, 0
    jne _continue_pas_zero
    movzx rax, byte [rsi] ; met le char dans rax
    sub eax, 0x30 ; en fait un entier
    mov edx, 10 
    mul edx ; mul ce char par 10
    movzx r13, byte [rsi+rcx+0x1] ; met le prochain char dans r13
    sub r13, 0x30
    add rax, r13
    push rax
    ;mov [int_atoi+rcx], rax
    add rsi, 2
    inc rcx
    jmp _a_l

_continue_pas_zero:
    pop rax
    mov edx, 10 
    mul edx ; mul ce char par 10
    push rax
    movzx rax, byte [rsi]
    sub rax, 0x30 ; en fait un entier
    pop r8
    add r8, rax
    push r8
    inc rsi
    inc rcx
    jmp _a_l

_a:
    mov eax, r8d
    jmp _ret
    ;jmp _remplir_tableau

_zero_pas_bo:
    mov rsi, rdi
    movzx rax, byte [rsi]
    sub rax, 0x30
    jmp _ret

_un_pa_bo_ossi:
    mov rsi, rdi
    movzx rax, byte [rsi]
    sub rax, 0x30
    mov edx, 10
    mul edx
    mov r8, rax
    inc rsi
    movzx rax, byte [rsi]
    sub rax, 0x30
    add rax, r8
    jmp _ret

_tro_gran:
    mov rax, 1
    jmp _ret

_remplir_tableau:
    cmp r8, 0
    je _remplir_tableau_end
    mov r13, r8
    ;movzx byte [rax], r13
    inc r8
    inc rax
    inc rcx
    jmp _remplir_tableau

_remplir_tableau_end:
    mov rax, r8
    jmp _ret

check_string:
    push rbp
    mov rbp, rsp
    mov rax, rdi
    mov rcx, 0
    jmp check_string_loop

check_string_loop:
    cmp byte [rax], 0
    je check_string_end
    cmp byte [rax], 0x30
    jl Bad_format
    cmp byte [rax], 0x39
    jg Bad_format
    inc rax
    jmp check_string_loop

check_string_end:
    mov rax, 0
    jmp _ret

Bad_format:
;    mov rax, 0x1
;    mov rdi, 0x1
;    mov rsi, Bad_format_string
;    mov rdx, Bad_format_string_len
;    syscall
    mov rax, 1
    jmp _ret

_prnt_string:
    push rbp ; 
    mov rbp, rsp ;
    call _strlen
    push rax
    push rdi ; 
    mov rax, 1 ; 
    mov rdi, 1 ; 
    pop rsi ; 
    pop rdx ; 
    syscall ; 
    jmp _ret ; 

;==================================================================


_clear_n:
    push rbp
    mov rbp, rsp
    mov rcx, 0
    mov rax, rdi
    jmp _loop_a

_loop_a:
    cmp byte [rax], 0xa
    je _end_a
    inc rax
    jmp _loop_a

_end_a:
    mov byte [rax], 0x0 ; \n
    mov rax, rdi
    jmp _ret



;==================================================================

_strlen:
    push rbp
    mov rbp, rsp
    mov rcx, 0
    mov rax, rdi
    jmp _loop

_loop:
    cmp byte [rax], 0
    je _end
    inc rax
    inc rcx
    jmp _loop

_end:
    mov rax, rcx
    jmp _ret


