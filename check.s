@ check.s			check(pile[], goal[])
@			takes the pile[] and compares it with our goal[] pile
@
@ 4.24.2020
@ Cody McKinney

@ Define Pi
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.syntax	unified

@ Program Code
	.text
	.align	2
	.global	check
	.type	check, %function

check:
	push	{fp, lr}
	add		fp, sp, #4
	sub		sp, sp, #20
	
	str		r0, [fp, #-16]	@ store pile[] [fp, #-16]
	str		r1, [fp, #-20]	@ store goal[] [fp, #-20]
	
	mov		r3, #0			@ int i = 0 in r3
	str		r3, [fp, #-8]	@ i [fp, #-8]
		
	b		condition
	
loop:
	ldr		r3, [fp, #-8]	@ r3 = i
	lsl		r3, r3, #2		@ calculate offset for i
	
	ldr		r2, [fp, #-16]	@ r2 = pile[]
	add		r3, r2, r3		@ r3 = pile[] at first element + i offset
	ldr		r2, [r3]		@ load r2 with what r3 is pointing too
	
	ldr		r3, [fp, #-8]	@ r3 = i
	lsl		r3, r3, #2		@ calculate offset for i
	
	ldr		r1, [fp, #-20]	@ r1 = goal[]
	add		r3, r1, r3		@ r3 = goal[] at first element + i offset
	ldr		r3, [r3]		@ load r3 with what r3 is pointing to
	
	cmp		r2, r3			@ r2 = r3	pile[i] = goal[i]
	beq		increment		@ if (pile[i] = goal[i])  back to condition
	
	mov		r3, #0			@ return 0 because pile[i] != goal[i]
	b		end
	
increment:
	ldr		r3, [fp, #-8]	@ r3 = i
	add		r3, r3, #1		@ i++
	str		r3, [fp, #-8]	@ updated i [fp, #-8]
	
condition:
	ldr		r3, [fp, #-8]	@ r3 = i
	cmp		r3, #8			@ i <= 8
	blt		loop			@ branch to loop
	mov		r3, #1			@ return 1 because pile[] = goal[]
	
end:
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}
