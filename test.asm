.text
.global main
.global draw_horizontal_line

main:
    
    li $v0, 30
    syscall
    li $a0, 5        ; x1
    li $a1, 250       ; x2
    li $a2, 10        ; y
    li $a3, 0x00FF0000 ; color blanco
    jal draw_horizontal_line
    li $a0, 5        ; x1
    li $a1, 250       ; x2
    li $a2, 110        ; y
    li $a3, 0x00FF0000 ; color blanco
    jal draw_horizontal_line

loop:
    li $v0, 104 ; Mantener vivo el proceso
    li $a0, 100
    syscall
    
    li $v0, 101
    syscall
    j loop


wait_engine:
    li $v0, 31      ; syscall: isReady
    syscall
    beqz $v0, wait_engine  ; 
    
    li $a0, 10        ; x1
    li $a1, 100       ; x2
    li $a2, 50        ; y
    li $a3, 0x00FF0000 ; color blanco
    jal draw_horizontal_line

   


draw_horizontal_line:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    ; a0 = x1, a1 = x2, a2 = y, a3 = color
    slt $t0, $a0, $a1 ; si x1 < x2 pasa al loop de una
    beqz $t0, swap
    move $t1, $a0
    move $t2, $a1
    j setup

swap:
    move $t1, $a1
    move $t2, $a0

setup:
    subu $t3, $t2, $t1  ; length = x_end - x_start
    addi $t3, $t3, 1   ; incluir último pixel

    move $a1, $a2       ; y
    move $a2, $a3       ; color

    li $t0, 0            ; i = 0

loop_start:
    slt $t4, $t0, $t3
    beqz $t4, loop_end
    li $v0, 100
    move $a0, $t1
    syscall
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_start



loop_end:

    
    ; flush para que se vean los cambios
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
