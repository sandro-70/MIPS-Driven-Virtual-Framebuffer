.text
.global main

main:
    ; Llamar syscall 100 → RunEngine()
    li $v0, 100
    syscall

    ; Mantener vivo el proceso
wait:
    li $v0, 104      ; Sleep
    li $a0, 100
    syscall
    j wait