; -----------------------------------------------------------------------
; NASM Exercicios - Software Basico 2021/1
; Grupo 4
; Ayssa Giovanna de Oliveira Marques - 170100065
; Gabriel Cesario Silva Martins - 180100912
; Joao Pedro Saderi da Silva - 170126021
; Matheus Barbosa Santos - 170053016
; Raylan da Silva Sales - 180108531
; -----------------------------------------------------------------------
; Objetivo: Construa macros para simular o comando switch em C
; -----------------------------------------------------------------------
extern _printf
global _main

;----------------------------------------------------------------------
; SWITCH-CASE 
; Forma geral:
;   SWITCH <expression>
;     CASE <argument1>
;       statements
;       BREAK
;     CASE <argumentN>
;       statements
;       BREAK
;     DEFAULT
;       statements
;   ENDSWITCH
;----------------------------------------------------------------------


;----------------------------------------------------------------------
; SWITCH <expression>
;   <expression> : DWORD valor inteiro de 32 bits 
;----------------------------------------------------------------------
%imacro SWITCH 1
  %push SWITCH                    ; Salva o contexto
  %assign %$case 1                ; Atribui ao proximo case o valor de 1
    mov eax, dword %1             ; Salva o argumento em eax
    mov edx, dword 0              ; Reseta o valor de edx, para ser usado nas avaliacoes do case
%endmacro

;------------------------------------------------------------------------
; CASE <argument>
;   <argument> : valor inteiro de 32 bits para comparar com <expression>
; DESCRICAO: blocos de codigo que executam caso CASE <argument> seja 
; verdadeiro
;------------------------------------------------------------------------------------
%imacro CASE 1
  %ifctx SWITCH                 ; Verifica o contexto
    %$next%$case:
    %assign %$case %$case+1     ; Incrementa o indice do case, para que o proximo case ser executado

    cmp edx, dword 1            ; Verifica se algum case foi avaliado corretamente 
    je %%skip

    cmp eax, %1                 ;  Compara <expression> com <argument>
    jne %$next%$case            ; Caso nao sejam iguais, pula para o proximo case
    mov edx, dword 1            ; Armazena 1 em edx caso o CASE seja corretamente avaliado: cases aninhados (sem breaks) 
                                ; vao passar sem avaliar uma expressao que ja foi avaliada corretamente 

    %%skip:
  %endif
%endmacro

;-------------------------------------------------------------------------------------
; DEFAULT 
; DESCRICAO: Caso todos os case falhem, executa o bloco de codigo 
;-------------------------------------------------------------------------------------
%imacro DEFAULT 0
  %ifctx SWITCH                 ; Verifica o contexto
    %define __DEFAULT
    %$next%$case:               ; Executa proximo bloco de codigo
  %endif
%endmacro

;-------------------------------------------------------------------------------------
; BREAK
; DESCRICAO: Saida do case
;-------------------------------------------------------------------------------------
%imacro BREAK 0
  %ifctx SWITCH                 ; Verifica o contexto
    
    mov edx, dword 0
    jmp %$break                 ; Sai do contexto do bloco
  %elifctx IF
    jmp %$break
  %endif
%endmacro

;----------------------------------------------------------------------
; ENDSWITCH 
; PURPOSE: Saida do bloco de switch e remove o contexto deste
;----------------------------------------------------------------------
%imacro ENDSWITCH 0
  %ifctx SWITCH                 ; Verifica o contexto
    %$break:                    ; Label do break
    %ifndef __DEFAULT           ; Check if DEFAULT
      %$next%$case:             ; Se nao, ENDSWITCH se torna o
                                ; nextcase
    %endif

    mov edx, dword 0            ; Reseta o valor de edx, para evitar erros em outros switchs
    %undef __DEFAULT            ; Libera DEFAULT
    %pop SWITCH                 ; Remove contexto do switch da pilha
  %endif
%endmacro

; --------------------------------------------------------------------------------------------------------------------------------------------
; Macros auxiliares

%imacro printInt 1
    push dword %1
    push msg
    call _printf
    add esp, 8
%endmacro

%imacro printStr 1
  push %1
  call _printf
  add esp, 4

%endmacro

; --------------------------------------------------------------------------------------------------------------------------------------------
section .data
  msg: db "Seu inteiro = %#d", 10, 0
  msg_teste1: db "----- Teste 1 -----", 10, 0
  msg_teste2: db "----- Teste 2 -----", 10, 0
  msg_not_found: db `Inteiro nao encontrado em nenhum case!\n`, 0
  endl: db `\n`, 0

  mem_val: dd -5
section .text
_main:

  printStr msg_teste1
  mov ebx, 1

back_switch:

  SWITCH ebx
    CASE 1
      printInt ebx
      add ebx, 1
      BREAK

    CASE 2
      printInt ebx
      add ebx, 1
      BREAK

    CASE 3
      printInt ebx
      add ebx, 1
      BREAK

    CASE 4
      printInt ebx
      add ebx, 1
      BREAK

    CASE 5
      printInt ebx
      add ebx, 1
      BREAK

    DEFAULT
      printStr msg_not_found ; Mostra na tela que o inteiro nao foi encontrado
      printInt ebx
      printStr endl           ; Printando fim de linha

      jmp next_teste
  ENDSWITCH

  jmp back_switch

next_teste:

  printStr msg_teste2
  mov ebx, -10

back_switch1:
  SWITCH ebx
    CASE -1
    CASE -2
    CASE -3
    CASE -4
    CASE [mem_val]
    CASE -6
    CASE -7
    CASE -8
    CASE -9
    CASE -10

    CASE 0

    CASE 1
    CASE 2
    CASE 3
    CASE 4
    CASE ecx
    CASE 5
      printInt ebx
      add ebx, 1
      mov ecx, 6
      BREAK

    DEFAULT
      printStr msg_not_found
      printInt ebx
      printStr endl
      jmp end_teste

  ENDSWITCH

  jmp back_switch1


end_teste:
  ret
