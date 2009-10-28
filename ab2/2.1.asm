.data
	matrix: .word 1, 6, 9, 5, 1
			.word 6, 3, 5, 6, 2
			.word 9, 5, 3, 3, 1
			.word 5, 6, 3, 1, 2
			.word 1, 2, 1, 2, 4
	n: .word 5
	good: .asciiz "symmetrisch"
	bad: .asciiz "nicht symmetrisch"
	position: .asciiz "Position: "
	space:		.asciiz " "
	newline:	.asciiz "\n"
.text
.globl main

main:

	#indices
	li		$t0, 0
	li		$t1, 0
	#dimensions
	la		$t9, n
	lw		$t9, ($t9)
	li		$t8, 4			#$t8 = word length
	mul		$t7, $t9, $t8	#$t7 = line length
		

head:
	jal		printdebug
	move	$a0, $t0
	move	$a1, $t1
	jal		getvalue
	move	$s0, $v0
	
	move	$a0, $t1
	move	$a1, $t0
	jal		getvalue
	move	$s1, $v0

	bne		$s0, $s1, badexit
	
#loop control
	addi	$t0, $t0, 1
	blt		$t0, $t9, head		#t0 smaller word length
	li		$t0, 0				#reset to start and move next row
	addi	$t1, $t1, 1
	blt		$t1, $t9, head
	j		exit
	
badexit:
	#write not symm
	la		$a0, bad
	li		$v0, 4
	syscall
	j		term

exit:
	la		$a0, good
	li		$v0, 4
	syscall
	j		term
term:
	li		$v0, 10	
	syscall
	

	#calculate address
getvalue:
	mul		$t2, $a0, $t8	#row position
	mul		$t3, $a1, $t7	#line offset
	add		$t2, $t2, $t3

	la 		$t5, matrix		#matrix start address
	add		$t5, $t5, $t2
	lw		$v0, ($t5)
	jr		$ra

printdebug:
	li		$v0, 4
	la		$a0, position
	syscall
	li		$v0, 1
	move	$a0, $t0
	syscall
	
	li		$v0, 4
	la		$a0, space
	syscall

	li		$v0, 1
	move	$a0, $t1
	syscall

	li		$v0, 4
	la		$a0, newline	
	syscall

	jr		$ra