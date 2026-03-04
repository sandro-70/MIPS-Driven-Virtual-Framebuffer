.text
.global main
.global draw_horizontal_line

main:
    
    li $v0, 30
    syscall
    

    li $a0, 20         ; x1
    li $a1, 10         ; y1
    li $a2, 210        ; w
    li $a3, 90         ; h
    li $s0 , 0x00FF0000; color 
    jal draw_rectangle

    li $a0, 10
    li $a1, 10
    li $a2, 0x00FFFFFF
    li $v0, 100
    syscall
    

loop:
    li $v0, 104 ; Mantener vivo el proceso
    li $a0, 100
    syscall

    li $v0, 103      ; getKey
    syscall
    li $t0, 1        ; UP
    beq $v0, $t0, up_pressed

    li $t0, 2        ; DOWN
    beq $v0, $t0, down_pressed

    li $t0, 3        ; LEFT
    beq $v0, $t0, left_pressed

    li $t0, 4        ; RIGHT
    beq $v0, $t0, right_pressed

    li $t0, 5        ; SPACE
    beq $v0, $t0, space_pressed
   
    li $v0, 101
    syscall
    j loop


up_pressed:

down_pressed:

left_pressed:

right_pressed:

space_pressed:


    li $v0, 105
    li $a0, 10
    li $a1, 10
    li $a2, 0x00FFFFFF
    syscall

    j loop
       


    

draw_rectangle:

     addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $s0, 16($sp)
    sw $s1, 12($sp)
    sw $s2, 8($sp)
    sw $s3, 4($sp)
    sw $s4, 0($sp)
    
     ; args
    move $s4, $s0 ; color
    move $s0, $a0        ; x
    move $s1, $a1        ; y
    add  $s2, $a0, $a2   ; x2 = x + w
    add  $s3, $a1, $a3   ; y2 = y + h
           

    ; top
    move $a0, $s0
    move $a1, $s2
    move $a2, $s1
    move $a3, $s4
    jal draw_horizontal_line

    ; bottom
    move $a0, $s0
    move $a1, $s2
    move $a2, $s3
    move $a3, $s4
    jal draw_horizontal_line

    ; left
    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s4
    jal draw_vertical_line

    ; right
    move $a0, $s2
    move $a1, $s1
    move $a2, $s3
    move $a3, $s4
    jal draw_vertical_line

    lw $s4, 0($sp)
    lw $s3, 4($sp)
    lw $s2, 8($sp)
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra

    




draw_vertical_line:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    ; a0 = x, a1 = y1, a2 = y2, a3 = color
    slt $t0, $a1, $a2     ; si y1 < y2
    beqz $t0, swap_v
    nop

    move $t1, $a1         ; y_start
    move $t2, $a2         ; y_end
    j setup_v
    nop

swap_v:
    move $t1, $a2
    move $t2, $a1

setup_v:
    subu $t3, $t2, $t1    ; length = y_end - y_start
    addi $t3, $t3, 1

    move $t5, $a0         ; x fijo
    move $t6, $a3         ; color

    li $t0, 0             ; i = 0

loop_start_v:
    slt $t4, $t0, $t3
    beqz $t4, loop_end_v
    nop

    li $v0, 100           ; draw pixel
    move $a0, $t5         ; x
    move $a1, $t1         ; y
    move $a2, $t6         ; color
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_start_v
    nop

loop_end_v:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
   


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

    
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
