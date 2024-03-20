.section .startup
b _start
b.

_start:
    ldr sp, stack_top_addr
    mov r0, pc
    add lr, r0, #4
    ldr pc, main_addr
    b.

.data
.equ RED_SIGNAL, 2
.equ AMBAR_SIGNAL, 1
.equ GREEN_SIGNAL, 0

.equ WARNING_TIME, 300
.equ CRITICAL_TIME, 150


color_histogram: 
    .space 3
    .align

times:
    .word 65535 , 500, 301, 300, 299, 151, 150, 149, 1, 0

color_scale:
    mov r0, GREEN_SIGNAL

