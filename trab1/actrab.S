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
    push    lr
    push    r4
    push    r5
    
    mov     r3, #0
    mov     r4, #3
    ldr     r1, color_histogram_addr
    mov     r5, #0
    
    


    
main_while:
    strb    r5, [r1,r3]
    add     r3, r3, #1
    cmp     r3, r4
    blo     main_while

    ldr     r0, times_addr
    mov     r2, #20
    bl      test_color_scale
    pop     pc


color_histogram_addr:
    .word   color_histogram

times_addr:
    .word times

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
    push    lr
    push    r4
    push    r5
    mov     r3, #0
    
test_color_scale_for:
    cmp     r3, r2
    bhs     test_color_scale_end

    ldr     r4, [r0 , r3]   ;array_t[i]
    push    r0
    mov     r0, r4
    b       color_scale
    mov     r4, r0
    pop     r0
    ldr     r5, [r1, r4]
    add     r5, r5, #1
    str     r5, [r1, r4]

    add     r3, r3, #2
    b       test_color_scale_for

test_color_scale_end:
    pop     r5
    pop     r4
    pop     pc

.bss

color_histogram: 
    .space      3
    .align



.data

times:
    .word       65535 , 500, 301, 300, 299, 151, 150, 149, 1, 0

/*  
Respostas:

1
 b) -> O número de bytes que é necessário para esta implementação é 0,
        pois o compilador substitui o nome dos símbolos pelo seu valor,
        não sendo necessário armazenar nenhum valor em memória.

2    -> Foi implementado o color_histogram na secção .bss pois
        esta secção tem como objetivo agrupar variáveis que são declaradas
        mas ainda não têm um valor, e o times na secção .data, pois, ao 
        contrário do color_histogram, esta começa com um valor atribuido,
        que é precisamente para isso que serve o .data .

3
 b)    -> A implementação da função color_scale tem 16 instruções,
          cada uma ocupando 2 bytes -- 16*2 = 32 -- 32 bytes no total.

4
 a)  -> A afirmação é verdadeira, pois o i é uma variável de rotina não folha.
        Por convenção as variáveis de rotina são armazenados no registo 4.


*/


    .equ        STACK_SIZE, 64
    .section    .stack
	.space      STACK_SIZE
    
stack_top:

