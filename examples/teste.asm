
global _main
extern _printf

section .data
    ; Sua string primeiro + fim de linha + \0
    int1: db "8", 0
    int2: db "5", 0
    space: db " ", 0
    endl: db `\n`, 0
    int_format: db "%#d", 0
    msg: db "Seu inteiro = %#d", 10 0

section .text

%macro printaStr 1
    push %1
    call _printf
    add esp, 4
%endmacro

%macro exit_sucess 0
    ret
%endmacro

_main:
    printaStr msg
    mov eax, 8
    add eax, 10
    push eax
    printaStr int_format
    add esp, 4
    printaStr endl

    exit_sucess