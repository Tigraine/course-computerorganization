.data

input_prompt:		
			.asciiz "Bitte Zeichenkette eingeben: "
pali:		.asciiz "Zeichenkette ist ein palindrom"
nopali:		.asciiz "Zeichenkette ist kein palindrom"
spc:		.asciiz " : "
crlf:		.asciiz "\n"
input:		.space 50
	
.text
.globl main

main:
	add		$t9, $zero, $zero		#reset $t9
	
	#promt user
	li		$v0, 4
	la		$a0, input_prompt
	syscall

	li		$v0, 8
	la		$a0, input
	li		$a1, 50
	syscall
	
	#find end
	la		$t1, input
	la		$t2, input
seek_start:
	lb		$t3, ($t2)
	beqz	$t3, found_end
	addu	$t2, $t2, 1
	addi	$t9, $t9, 1
	j		seek_start

found_end:
	subu	$t2, $t2, 2
	sub		$t9, $t9, 1
	
	#palindrom check
	#t1 points to start 
	#t2 points to end
	
test_loop:
	lb		$t3, ($t1)
	lb		$t4, ($t2)
	
	#fix input to uppercase
	blt		$t3, 97, lowercase_3
	blt		$t4, 97, lowercase_4
	j		end_fix
lowercase_3:
	addi	$t3, $t3, 32
	j		end_fix
lowercase_4:
	addi	$t4, $t4, 32
	j		end_fix
end_fix:
	
	j		debug
dbg:
	bne		$t3, $t4, no_palin
	addu	$t1, $t1, 1
	subu	$t2, $t2, 1
	sub		$t9, $t9, 1
	beqz	$t9, is_palin
	j		test_loop
	
no_palin:
	li		$v0, 4
	la		$a0, nopali
	syscall
	j 		end
is_palin:
	li		$v0, 4
	la		$a0, pali
	syscall
	j		end

end:
	li		$v0, 10
	syscall
	
debug:
	li		$v0, 1
	add		$a0, $t3, $zero
	syscall
	
	li		$v0, 4
	la		$a0, spc
	syscall
	
	li		$v0, 1
	add		$a0, $t4, $zero
	syscall
	
	li		$v0, 4
	la		$a0, crlf
	syscall
	
	j		dbg