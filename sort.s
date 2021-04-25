@ sort.s     call sort(array object, size of array n)
@	     		sort will sort an array of size n
@
@ 4.19.2021
@ Cody McKinney (in class)

@ Define Pi
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.syntax	unified

@ Program Code
	.text
	.align	2
	.global	sort
	.type	sort, %function

sort:
	push	{fp, lr}
	add	fp, sp, #4

	@ assume r0 contains address of array ( first element of array )
	@ assume r1 contains # elements in the array

	@ r10 = i	r9 = j

	mov	r10, 0		@ outer loop:

outerLoop:
	sub	r2, r1, #1
	cmp	r10, r2
	bge	endOuterLoop

	@ r9 = r10 + 1		@ j = i + 1
	add	r9, r10, #1

innerLoop:
	cmp	r9, r1
	bge	endInnerLoop

	@ perform the swap if element at r9 is < element at r10

	mov	r2, r9, LSL #2
	ldr	r2, [r0, r2]	@ r0[r2] = r2 	 *(r0 + r2)

	@ load value at r10 -> r3	r10 * 4
	mov	r3, r10, LSL #2
	ldr	r3, [r0, r3]


	@ x[j] < x[i] swap	r2 < r3 -> swap
	cmp	r2, r3
	bge	skipSwap

	@ r2 -> r0[r10]
	@ r3 -> r0[r9]

	mov	r8, r10, LSL #2
	str	r2, [r0, r8]
	mov	r8, r9, LSL #2
	str	r3, [r0, r8]

skipSwap:
	add	r9, r9, #1	@ j = j + 1
	b	innerLoop

endInnerLoop:
	add	r10, r10, #1
	b	outerLoop

endOuterLoop:
	sub	sp, fp, #4
	pop	{fp, pc}

