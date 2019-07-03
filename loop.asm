;       Les syscalls prennent leurs arguments dans les regs  %rdi, %rsi, %rdx, %r10, %r8 et %r9
;
BITS 64

section .data
    Good_Args db `[*] Lancement du programme \n`, 0h ; '\0'
    Good_Args_len equ $-Good_Args

section .text
    global _start; l'EP ici

_start:
    mov rcx, 10 ; 10-1 == 9 mov r10, 0 ; r10 est bon, mais r11 et rcx sont détruis
    jmp _loop

_loop:
    mov rax, 1 ; syscall number
    mov rdi, 1 ; stdout
    mov rsi, Good_Args ; [valeur]
    mov rdx, Good_Args_len ; size
    push rcx
    syscall ;
    pop rcx
    cmp rcx, 0 ; cmp r10, 0
    je exit ; jump if equal
    ;inc r12 ; inc r12 ; décrémentataion de r10 == r12-- == r12 = r12-1
    loop _loop ; dec rcx && jmp <étiquette>

exit:
    mov rax, 60
    mov rdi, 0
    syscall

;#include <stdio.h>
;
;int main(){
;    int i;
;    for(i=10; i>0; i--){
;        printf("[*] Lancement du programme ");
;    }
;    return 0;
;}

;#include <stdio.h>
;
;int main(){
;    int i=0;
;    do{
;        printf("[*] Lancement du programme ");
;        i++;
;    }while(i<10)
;    return 0;
;}

;#include <stdio.h>
;
;int main(){
;    int i;
;    for(i=0; i<10; i++){
;        printf("[*] Lancement du programme \n");
;    }
;    return 0;
;}

;#include <stdio.h>
;
;int main(){
;    int i=0;
;    while(i<10){
;        printf("[*] Lancement du programme \n");
;        i++;
;    }
;    return 0;
;}