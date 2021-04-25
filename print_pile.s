@ print_table.s  print_table() takes the array and array count
@				 and prints out a list of array contents
@
@ 4.17.2020
@ Cody McKinney

@ Define Pi
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.syntax	unified

	.data
outp:
	.asciz	"%d "		@ prints out our array value at index i

@ Program Code
	.text
	.align	2
	.global	print_pile
	.type	print_pile, %function

print_pile:
	push	{fp, lr}
	add		fp, sp, #4
	sub		sp, sp, #16

	str		r0, [fp, #-16]	@ r0 now holds my array  r0 = pile[]
	str		r1, [fp, #-20]	@ r1 is my array size    r1 = size
	
	mov		r3, #0			@ int j = 0
	str	r3, [fp, #-8]		@ store j on the stack [fp, #-8]
	b		printcondition		@ branch to condition
	
loop:
	ldr	r3, [fp, #-8]		@ r3 = j
	lsl	r3, r3, #2			@ calculate j offset
	ldr	r2, [fp, #-16]		@ r2 = pile[]
	add	r3, r2, r3			@ pile[] at first index + j offset
	ldr	r3, [r3]			@ r3 = what r3 is pointing at
	mov	r1, r3				@ what r3 is pointing at to r1 = pile[j]
	
	ldr	r0, =outp			@ "%d "
	bl	printf				@ prints output
	
	ldr	r3, [fp, #-8]		@ r3 = j
	add	r3, r3, #1			@ j++
	str	r3, [fp, #-8]		@ update j on stack [fp, #-8]
	
printcondition:
	ldr		r2, [fp, #-8]	@ r2 = j
	ldr		r3, [fp, #-20]	@ r3 = size
	cmp		r2, r3			@ r2 < r3	j < size
	blt		loop

end:
	mov 	r0, #10			@ print new line 
	bl		putchar			@ 10 as character is \n

	sub		sp, fp, #4
	pop		{fp, pc}
