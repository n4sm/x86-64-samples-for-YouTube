BITS 64

; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=

;                                                   Les chaines de char

; Trois instructions importantes :

; lods[length] : Load string, rsi -> 0x7ffffff500 ('nasm')

; stos[length] : Store string, rdi -> 0x7ffffff700 ('0x6e')

; movs[length] : mov string

; Quelques révisions sur le direction flag : 

; - DF set (1), décrémentation des pointeurs

; - DF non set (0), incrémentation des pointeurs 

; Le manipuler : std -> DF à 1
;                cld -> DF à 0


; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=

section .data
        p_plaintext db "Plain text : ", 0x0
        p_plaintext_len equ $-p_plaintext

        p_encoded_text db "Encoded text : ", 0x0
        p_encoded_text_len equ $-p_encoded_text

        rtn_char db 0xa

section .text
    global _start

_start:
    call _main_entry__
    mov rax, 60
    syscall

_main_entry__:
    push rbp
    mov rbp, rsp
    cmp byte [rbp+0x10], 2 ; On check que il ait mis un argument
    jne _ret
    mov rsi, [rbp+32] ; Notre argument utilisateur
    mov rdi, rsi ; argument pour strlen
    call _strlen
    cmp rax, 0x8
    jg __overflow_
    mov r8, rax ; Taille dans R8
    mov rcx, rax
    sub rsp, 0x8
    lea rdi, [rbp-0x8] ; ptr vers l'espace qui vient d'etre créé
    cld ; On clear le DF
    ;push rcx ; On se fait pas chier
    jmp _loop_encoding__


_loop_encoding__:
    lodsb
    ; ===== Notre encodage =====
    xor al, 0x5
    sub al, 0x3
    ;or al, 0x9
    ; ===== Fin de l'encodage ====
    stosb
    loop _loop_encoding__
    jmp __print_remain

    ; ============********************===== Passage aux prints  =====********************=====
__print_remain:
    mov rax, 0x1
    push rdi ; Ici le push
    mov rdi, 0x1
    mov rsi, p_plaintext
    mov rdx, p_plaintext_len
    syscall
    
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, [rbp+32] ; 40 + 8 car on a fais un push entre temps
    mov rdx, r8
    ;push rdx
    syscall
    
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, rtn_char
    mov rdx, 0x1
    syscall
    
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, p_encoded_text
    mov rdx, p_encoded_text_len
    syscall
    
    mov rax, 0x1
    mov rdi, 0x1
    mov rdx, r8
    lea rsi, [rbp-0x8] ; rsp + 16 => 
    syscall
    
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, rtn_char
    mov rdx, 0x1
    syscall
    
    jmp _ret


__overflow_:
    mov rax, 60
    syscall

;==================================

; Réimplémentation des fonctions de la libc en nasm 64 bits
; Une fonction qui calcule la taille d'une chaine de caractère en octets

;=================================

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


;========================

;   This fonction will clear the \n of a string
;   Prototype : *clear_n(*string)

;========================

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

exit:
    mov rax, 60
    mov rdi, 0
    syscall

_ret:
    leave ; mov rsp, rbp ; pop rbp
    ret ; pop rip && jmp rip
