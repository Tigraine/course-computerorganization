.data

	arr: .word 13 41 20 42 -10 35 -20 43 34 11 53 -12 30 -123 111
	arrSize: .word 15
	crlf:	.asciiz "\n"
	sum:	.asciiz "Summe aller Arrayelemente: "
	gerade:	.asciiz ": gerade"
	ungerade: .asciiz ": ungerade"
.text
.globl main

main:
	li		$t8, 2

	la		$t0, arr
	lw		$t1, arrSize

head:
	lw		$t2, ($t0)
	
	#Number out
	li		$v0, 1
	add		$a0, $t2, $zero
	syscall
	
	rem		$t3, $t2, $t8			#$t3 = $t2 mod 2
	beqz	$t3, eq
	
	li		$v0, 4
	la		$a0, ungerade
	syscall
	
	j 		continue
	
eq:
	li		$v0, 4
	la		$a0, gerade
	syscall
continue:
	
	#add to sum
	add		$t9, $t9, $t2
	
	#print newline
	li		$v0, 4
	la		$a0, crlf
	syscall
	
	addi	$t0, $t0, 4
	#increment loop counter
	addi 	$t1, $t1, -1
	#exit loop
	beqz	$t1, end
	
	j head	#jump back to loop

end:	
	
	li		$v0, 4
	la		$a0, sum
	syscall
	li		$v0, 1
	add		$a0, $t9, $zero
	syscall

	li		$v0, 10
	syscall
