.data
	result:	.asciiz 	"Fibonacci Zahl f(n): "
	input:	.asciiz 	"Die wievielte Zahl wollen Sie berechnen?: "
.text

.globl main

main:

	li		$s7, 2

	la		$a0, input
	jal		write
	
	jal		read
	move	$s0, $v0


	move	$a0, $s0
	jal		fib
	move	$s1, $v0		#save return value

	la		$a0, result
	jal		write
	move	$a0, $s1
	jal		writeint

	j		exit			#end of program



fib:
	#li		$v0, 1
	#syscall

	blt		$a0, $s7, simple

	move	$t0, $sp
	addi	$sp, $sp, -16	#reserve 
	sw		$ra, 4($sp)		#preserve our return address
	sw		$fp, 8($sp)		#preserve our framepointer
	move	$fp, $t0		#set framepointer
	sw		$a0, 16($sp)	#keep our input parameter

	addi	$a0, $a0, -1
	jal		fib
	sw		$v0, 12($sp)	#save method returnvalue before calling next fib

	lw		$a0, 16($sp)
	addi	$a0, $a0, -2
	jal		fib

	lw		$t0, 12($sp)	#get saved fib(n-1) from stack
	add		$v0, $t0, $v0	#calculate result 

	lw		$ra, 4($sp)
	lw		$fp, 8($sp)
	addi	$sp, $sp, 16	#decrement sp by stackframe
	jr		$ra
	
simple:
	move	$v0, $a0
	jr		$ra

write:
	li		$v0, 4
	syscall
	jr		$ra
writeint:
	li		$v0, 1
	syscall
	jr		$ra
read:
	li		$v0, 5
	syscall
	jr		$ra

exit:
	li		$v0, 10
	syscall