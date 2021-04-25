@ play_game.s	play_game(array, size of array)
@				play_game() will solve the bulgarian solitaire game
@		calls: mod.s print_pile.s remove_zero.s sort.s check.s
@
@ 4.24.2020
@ Cody McKinney


@ Define Pi
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.syntax	unified

	.data
goal:
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	9
start:
	.asciz	"Starting pile: "

size:
	.asciz	"Number of piles to start: %d\n"

next:
	.asciz	"Next pile: "

final:
	.asciz	"Final Pile Sorted: "

@ Program Code
	.text
	.align	2
	.global play_game
	.type	play_game, %function

play_game:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #72

	str	r0, [fp, #-72]		@ store pile[] on stack [fp, #-72]
	ldr	r3, =goal		@ load r3 with 1,2,3,4,5,6,7,8,9

	/* storing goal[] = {1,2,3,4,5,6,7,8,9} on stack */
	sub	ip, fp, #68
	mov	lr, r3
	ldmia	lr!, {r0, r1, r2, r3}
	stmia	ip!, {r0, r1, r2, r3}
	ldmia	lr!, {r0, r1, r2, r3}
	stmia	ip!, {r0, r1, r2, r3}
	ldr	r3, [lr]
	str	r3, [ip]

	mov	r3, #45			@ r3 = (total = 45)
	str	r3, [fp, #-8]		@ total [fp, #-8]

	mov	r3, #0			@ r3 = (size = 0)
	str	r3, [fp, #-12]		@ size [fp, #-12]

	/* seed for our random # using time */
	mov	r0, #0
	bl	time
	mov	r3, r0
	mov	r0, r3
	bl	srand

	ldr	r0, =start	@ "Starting pile: "
	bl	printf

	mov	r3, #0			@ inititalize int i = 0 for first for loop
	str	r3, [fp, #-16]		@ i = 0 [fp, #-16]
	b	for1condition

for1loop:
	bl	rand
	mov	r3, r0			@ r3 = random #

	ldr	r1, [fp, #-8]		@ r1 = total
	mov	r0, r3				@ random # % total pass to mod
	bl	mod

	mov	r3, r0			@ r0 holds (rand() % total)
	add	r3, r3, #1		@ (rand() % total) + 1
	str	r3, [fp, #-28]		@ update random # stack

	ldr	r2, [fp, #-8]		@ r2 = total
	ldr	r3, [fp, #-28]		@ r3 = random

	sub	r3, r2, r3			@ r3 = total - random
	str	r3, [fp, #-8]		@ updated total [fp, #-8]

	ldr	r3, [fp, #-16]		@ r3 = i
	lsl	r3, r3, #2			@ calculate offset for i

	ldr	r2, [fp, #-72]		@ r2 = pile[] at first element
	add	r3, r2, r3			@ pile[] at i offset
	ldr	r2, [fp, #-28]		@ r2 = random
	str	r2, [r3]			@ store random # at pile[i]

	ldr	r3, [fp, #-12]		@ load r3 with size r3 = size
	add	r3, r3, #1			@ size++
	str	r3, [fp, #-12]		@ size stored [fp, #-12]

	ldr	r3, [fp, #-16]		@ r3 = i
	add	r3, r3, #1			@ i++
	str	r3, [fp, #-16]		@ i stored [fp, #-16]

for1condition:
	ldr	r3, [fp, #-8]		@ r3 = total
	cmp	r3, #0			@ total > 0
	bgt	for1loop		@ if total > 0 continue	to for1loop
					@ if total < 0
					@ print current pile[]

	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, [fp, #-72]		@ r0 = pile[] at first element
	bl	print_pile

	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, =size		@ "Number of piles to start: %d\n"
	bl	printf

whilecondition:
	mov	r3, #0			@ newPile = 0
	str	r3, [fp, #-24]		@ newPile [fp, #-24]

	mov	r3, #0			@ j = 0
	str	r3, [fp, #-20]		@ j [fp, #-20]
	b	whileloop

newpileloop:
	ldr	r3, [fp, #-20]		@ r3 = j
	lsl	r3, r3, #2			@ calculate offset for j

	ldr	r2, [fp, #-72]		@ r2 = pile[]
	add	r3, r2, r3			@ r3 = pile[] at j offset

	ldr	r2, [r3]			@ r2 = pile[j]

	ldr	r3, [fp, #-20]		@ r3 = 0
	lsl	r3, r3, #2			@ calculate offset for j
	ldr	r1, [fp, #-72]		@ r1 = pile[]

	add	r3, r1, r3		@ r3 = pile[] at j offset
	sub	r2, r2, #1		@ r2 = pile[j] - 1
	str	r2, [r3]		@ r2 = pile[j] = pile[j - 1]

	ldr	r3, [fp, #-24]		@ r3 = newPile
	add	r3, r3, #1			@ newPile++
	str	r3, [fp, #-24]		@ update newPile on [fp, #-24]

	ldr	r3, [fp, #-20]		@ r3 = j
	add	r3, r3, #1			@ j++
	str	r3, [fp, #-20]		@ updated j back [fp, #-20]

whileloop:
	ldr	r2, [fp, #-20]		@ r2 = j
	ldr	r3, [fp, #-12]		@ r3 = size
	cmp	r2, r3				@ j < size
	blt	newpileloop

	ldr	r3, [fp, #-12]		@ r3 = size
	add	r3, r3, #1			@ size++
	str	r3, [fp, #-12]		@ store new size [fp, #-12]

	ldr	r3, [fp, #-12]		@ r3 = size
	sub	r3, r3, #-1073741823	@ max # for offset, not sure why?
								@ I was playing around w gcc compiler for arrays
								@ I cant seem to get this to work without the gcc's method
	lsl	r3, r3, #2		@ offset for size

	ldr	r2, [fp, #-72]		@ r2 = pile[]
	add	r3, r2, r3			@ r3 = pile at offset pile[size - 1]
	ldr	r2, [fp, #-24]		@ r2 = newPile
						@ pile[size - 1] = newPile
						@ newPile stored at address of r3 (pile[size - 1])
	str	r2, [r3]

	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, [fp, #-72]		@ r0 = pile[] at first element
	bl	remove_zero

	str	r0, [fp, #-12]		@ updated size [fp, #-12]

	ldr	r0, =next			@ "Next pile: "
	bl	printf

	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, [fp, #-72]		@ r0 = pile[] at first element
	bl	print_pile

	ldr	r3, [fp, #-12]		@ r3 = size
	cmp	r3, #9				@ size == 9
	bne	whilecondition		@ if size != 9 we branch back to our while condition

					@ if size == 9
	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, [fp, #-72]		@ r0 = pile[] at first element
	bl	sort

	sub	r3, fp, #68		@ goal[] at first element to r3
	mov	r1, r3			@ goal[] to r1 for pass
	ldr	r0, [fp, #-72]		@ pile[] at first element to r0
	bl	check			@ r0 =  pile[] r1 = goal[] to pass

	mov	r3, r0			@ check() returns a flag 0 or 1
	cmp	r3, #0			@ 0 is false
	bne	end				@ if r3 != 0  if (true) break to end
	b	whilecondition		@ other wise branch back to while condition

end:
	ldr	r0, =final		@ "Final array sorted "
	bl	printf

	ldr	r1, [fp, #-12]		@ r1 = size
	ldr	r0, [fp, #-72]		@ r0 = pile[] at first element
	bl	print_pile

	sub	sp, fp, #4
	pop	{fp, pc}
	
