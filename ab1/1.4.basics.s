.data

str1:	.asciiz "Zahl 1:"
str2:	.asciiz "Zahl 2:"
str3:	.asciiz "Zahl 3:"
gleichseitig:
		.asciiz "Das Dreieck ist gleichseitig\n"
gleichschenkel:
		.asciiz "Das Dreieck ist gleichschenkelig\n"
none: 	.asciiz "Das Dreieck ist weder gleichseitig noch gleichschenkelig\n"
ng:		.asciiz "Nicht gleichseitig\n"
str_inv: .asciiz "Zahl muss größer als 0 sein!\n"

	.text
	.globl main    # declaration of main as a global variable

main:	

zahl1:
	li 		$v0, 4
	la		$a0, str1
	syscall
	li 		$v0, 5
	syscall
	add 	$t0, $v0, $zero
	
	la		$t5, zahl1
	bltz	$t0, invalid
	
zahl2:
	li 		$v0, 4
	la		$a0, str2
	syscall
	li		$v0, 5
	syscall
	add		$t1, $v0, $zero
	
	la		$t5, zahl2
	bltz	$t1, invalid
	
zahl3:
	li		$v0, 4
	la		$a0, str3
	syscall
	li		$v0, 5
	syscall
	add		$t2, $v0, $zero
	
	la		$t5, zahl3
	bltz	$t2, invalid
	
	#gleichseitig check
	li		$t4, 2
	mul	$t9, $t0, $t4	#$t9 = $t0*3
	sub		$t9, $t9, $t1
	sub 	$t9, $t9, $t2
	beqz	$t9, gleichS
	#nicht gleichseitig
	li		$v0, 4
	la		$a0, ng
	syscall
	
	#gleichschenkel check
	sub		$t9, $t0, $t1
	beqz	$t9, gleich2
	sub		$t9, $t1, $t2
	beqz	$t9, gleich2
	sub		$t9, $t0, $t2
	beqz	$t9, gleich2
	
	#nicht gleichschenkel
	li		$v0, 4
	la		$a0, none
	syscall
	
end:
	li		$v0, 10
	syscall
	#end
	
gleichS:
	li		$v0, 4
	la		$a0, gleichseitig
	syscall
	j gleich2
	
gleich2:
	li		$v0, 4
	la		$a0, gleichschenkel
	syscall
	j end
	
invalid:
	li		$v0, 4
	la		$a0, str_inv
	syscall
	jr		$t5