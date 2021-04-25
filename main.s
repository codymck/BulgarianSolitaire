@ main.s	call play_game(array, size of array)
@			play_game() will begin the bulgarian solitaire game
@		Driver Function
@
@ 4.24.2020
@ Cody McKinney 011160497


@ Define Pi
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.syntax	unified
	
@ Program Code
	.text
	.align	2
	.global	main
	.type	main, %function

main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #184		@ 184 = pile[46] memory = 46 * 4
	
	sub	r3, fp, #184
	mov	r0, r3				@ r0 is index of first array element
	bl	play_game			@ call play_game to run and solve solitaire
	
		@ return zero and end program
	mov	r3, #0	
	mov	r0, r3
	
	sub	sp, fp, #4
	pop	{fp, pc}
