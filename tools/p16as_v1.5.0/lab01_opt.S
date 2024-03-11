mov r2, #0
if:
	mov r3, #0
	cmp r0, r3    
beq if_end     
while:    
	mov r3, #0     
	cmp r3, r1
	bhs while_end  
	add r2, r2, r0 
	sub r1, r1, #1 
	b while         
while_end:      
if_end:            
b .             