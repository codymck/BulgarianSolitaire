@ mod.s     takes 2 numbers and finds the remainder if any
@
@ 4.24.2020
@ Cody McKinney

.cpu cortex-a53 
.fpu neon-fp-armv8

.text
.align 2
.global mod
.type mod, %function

mod:
   push {fp, lr}
   add fp, sp, #4

   UDIV r10, r0, r1     @ a / n = d
   MUL r10, r10, r1     @ d * n = p
   SUB r10, r0, r10     @ a - p = r
   mov r0, r10          @ r0 = remainder to pass 

   sub sp, fp, #4
   pop {fp, pc}
