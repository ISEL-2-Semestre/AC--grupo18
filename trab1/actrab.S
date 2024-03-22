	.section .startup
	b		_start
	b 		.
_start:
	ldr		sp, stack_top_addr
	mov		r0, pc
	add		lr, r0, #4
	ldr		pc, main_addr
	b 		.	

stack_top_addr:
	.word stack_top
main_addr:
	.word	main

;defines
.equ    RED_SCALE, 2
.equ    AMBAR_SCALE, 1
.equ    GREEN_SCALE, 0

.equ    WARNING_TIME, 300
.equ    CRITICAL_TIME, 150


.text

main:
    mov     pc, lr
    push    r4
    mov     r3, #0
    mov     r4, #3
    cmp     r3, r4
    blo     main_while
    b       test_color_scale
    mov     pc, #0
    


    
main_while:
    mov     color_histogram[r3], #0
    add     r3, r3, #1


color_scale:
    ;registos:
    ;r0 = t
    ;r4 = c
    ;r5 = WARNING_TIME
    ;r6 = CRITICAL_TIME
    ;por registos no stack
    push    r4
    push    r5
    push    r6
    ;associar valores aos registos
    mov     r4, #GREEN_SCALE
    mov     r5, #WARNING_TIME & 0xFF ;guardar somente os primeiros bits
    movt    r5, #WARNING_TIME >> 8
    mov     r6, #CRITICAL_TIME

    cmp     r0, r6
    blo     color_scale_if2
    cmp     r5, r0 
    blo     color_scale_if2
    mov     r4, #AMBAR_SCALE ;corpo do if1
    b       color_scale_end
    



color_scale_if2: ; corpo do if2
    mov     r4, #RED_SCALE

color_scale_end: ;retorna o c, r4
    pop     r6
    pop     r5

test_color_scale:
    ; r0 = array_t[]
    ; r1 = array_c[]
    ; r2 = array_t_size
    ; r3 = i
    ; r4 = color_scale(array_t[i])
    ; r5 = array_c[r4]
    push    r4
    push    r5
    mov     r3, #0
    
test_color_scale_for:
    cmp     r3, r2
    bge     test_color_scale_end

    ldr     r4, [r0 , r3]   ;array_t[i]
    push    r0
    mov     r0, r4
    b       color_scale
    mov     r4, r0
    pop     r0
    ldr     r5, [r1, r4]
    add     r5, r5, #1
    str     r5, [r1, r4]

    add     r3, r3, #1
    b       test_color_scale_for

test_color_scale_end:
    pop     r5
    pop     r4
    mov     pc, lr




.data

color_histogram: 
    .space      3
    .align

times:
    .word       65535 , 500, 301, 300, 299, 151, 150, 149, 1, 0


    .equ        STACK_SIZE, 64
    .section    .stack
	.space      STACK_SIZE
    
stack_top:






