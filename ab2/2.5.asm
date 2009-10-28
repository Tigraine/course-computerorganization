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

.text

.globl main

main:

	jal		read
	move	$s0, $v0
	jal		read
	move	$s1, $v0

	move	$a0, $s0
	move	$a1, $s1
	jal		func

	move	$a0, $v0
	jal		writeint


	j		exit			#end of program



func:
	move	$t0, $sp
	addi	$sp, $sp, -20	#reserve 
	sw		$ra, 4($sp)		#preserve our return address
	sw		$fp, 8($sp)		#preserve our framepointer
	move	$fp, $t0		#set framepointer
	sw		$a0, 12($sp)	#keep our input parameter
	sw		$a1, 16($sp)	#keep our input parameter

	#method body

	beqz	$a0, case1
	beqz	$a1, case2
	j		case3

	#method body end
cleanup:
	lw		$ra, 4($sp)
	lw		$fp, 8($sp)
	addi	$sp, $sp, 20	#decrement sp by stackframe
	jr		$ra
	
case1:
	addi	$v0, $a1, 1
	j		cleanup
case2:
	blez	$a0, case3		#in case b=0 but a<=0
	#f(a,b) = f(a-1, 1)
	#load a0 from stack
	lw		$a0, 12($sp)
	addi	$a0, $a0, -1
	li		$a1, 1
	jal		func
	#result is already in $v0

	j 		cleanup
case3:
	#f(a,b) = f(a-1, f(a, b-1))
	#load parameters from stack
	lw		$a0, 12($sp)
	lw		$a1, 16($sp)

	addi	$a1, $a1, -1
	jal		func
	move	$a1, $v0
	lw		$a0, 12($sp)
	addi	$a0, $a0, -1
	jal		func
	
	j		cleanup

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
