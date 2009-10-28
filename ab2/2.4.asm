#   Copyright 2009 Daniel Hölbling, http://www.tigraine.at
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

.data
	result:	.asciiz 	"Fibonacci Reihe: "
	space:	.asciiz 	", "
	input:	.asciiz 	"Die wievielte Zahl wollen Sie berechnen?: "
.text

.globl main

main:

	li		$s7, 2
	li		$s0, 0

	la		$a0, input
	jal		write
	
	jal		read
	move	$s3, $v0		#we want first 10 fibs

	la		$a0, result
	jal		write

head:
	addi	$s0, $s0, 1	
	
	move	$a0, $s0
	jal		fib
	move	$s1, $v0		#save return value

	move	$a0, $s1
	jal		writeint
	la		$a0, space
	jal		write

	bge		$s3, $s0, head

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