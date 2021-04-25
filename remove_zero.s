@ remove_zero.s		remove_zero(array, size of array)
@			remove_zero will take an array and a size, remove the zero
@			and return the new size of the array
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
	.global remove_zero
	.type	remove_zero, %function

remove_zero:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #20

	str	r0, [fp, #-16]		@ r0 = pile[] stored on [fp, #-16]
	str	r1, [fp, #-20]		@ r1 = size stored on [fp, #-20]
	mov	r3, #0			@ r3 = int i = 0
	str	r3, [fp, #-8]		@ i stored on [fp, #-8]
	b	condition

for:
	ldr	r3, [fp, #-8]		@ r3 = i
	lsl	r3, r3, #2			@ calculate offset for i
	ldr	r2, [fp, #-16]		@ r2 = pile[]
	add	r3, r2, r3		@ r3 = pile[] + i offset
	ldr	r3, [r3]		@ pile[i] = r3
	cmp	r3, #0			@ is pile[i] == 0
	bne	if2				@ if pile[i] != 0 branch to if2

	ldr	r3, [fp, #-20]			@ r3 = size
	sub	r3, r3, #-1073741823	@ max # to offset size pile[size - 1]
	lsl	r3, r3, #2				@ calculate size offset

	ldr	r2, [fp, #-16]		@ r2 = pile[]
	add	r3, r2, r3		@ pile[] at size offset
	ldr	r3, [r3]		@ r3 = address of r3 at offset
	cmp	r3, #0			@ pile[size - 1] == 0
	beq	if2				@ if pile[size - 1] == 0 branch to 2nd if

if1:
	ldr	r3, [fp, #-20]			@ r3 = size
	sub	r3, r3, #-1073741823	@ max # to offset size pile[size - 1]
	lsl	r3, r3, #2				@ calculate size offset

	ldr	r2, [fp, #-16]		@ r2 = pile[]
	add	r2, r2, r3			@ r2 = pile[size - 1]

	ldr	r3, [fp, #-8]		@ r3 = i
	lsl	r3, r3, #2			@ calculate offset for i
	ldr	r1, [fp, #-16]		@ r1 = pile[]
	add	r3, r1, r3			@ r3 = pile[i]

	ldr	r2, [r2]		@ r2 = pile[size - 1]
	str	r2, [r3]		@ pile[i] = pile[size - 1]

	ldr	r3, [fp, #-20]		@ r3 = size
	sub	r3, r3, #1			@ size--
	str	r3, [fp, #-20]		@ updated size [fp, #-20]

if2:
	ldr	r3, [fp, #-20]			@ r3 = size
	sub	r3, r3, #-1073741823	@ max # to offset size
	lsl	r3, r3, #2				@ calculate size offset

	ldr	r2, [fp, #-16]		@ r2 = pile[]
	add	r3, r2, r3			@ r3 = pile[] at size offset
	ldr	r3, [r3]			@ r3 = pile[size - 1]

	cmp	r3, #0				@ pile[size - 1] == 0
	bne	increment			@ if pile[size - 1] != 0

	ldr	r3, [fp, #-20]		@ r3 = size
	sub	r3, r3, #1			@ size--
	str	r3, [fp, #-20]		@ updated size [fp, #-20]

	ldr	r3, [fp, #-8]		@ r3 = i
	sub	r3, r3, #1			@ i--
	str	r3, [fp, #-8]		@ updated i [fp, #20]

increment:
	ldr	r3, [fp, #-8]		@ r3 = i
	add	r3, r3, #1			@ i++
	str	r3, [fp, #-8]		@ updated i [fp, #-20]

condition:
	ldr	r2, [fp, #-8]		@ r2 = i
	ldr	r3, [fp, #-20]		@ r3 = size
	cmp	r2, r3				@ i < size
	blt	for

end:
	ldr	r3, [fp, #-20]		@ r3 = size
	mov	r0, r3			@ r0 = size to return

	sub	sp, fp, #4
	pop	{fp, pc}
