#   Copyright 2009 Daniel H�lbling, http://www.tigraine.at
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
	ain:	.asciiz 	"a: "
	bin:	.asciiz		"b: "
	cin:	.asciiz		"c: "
	res:	.asciiz 	"Ergebnis: "
.text

.globl main

main:

	la		$a0, ain
	jal		write
	
	jal		read
	move	$s0, $v0

	la		$a0, bin
	jal		write

	jal		read
	move	$s1, $v0

	la		$a0, cin
	jal		write

	jal		read
	move	$s2, $v0

	move	$a0, $s0	
	move	$a1, $s1
	move	$a2, $s2
	jal		func
	move	$s3, $v0	#save result of func

	la		$a0, res
	jal		write

	move	$a0, $s3
	jal		writeint

	jal		end

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

func:
	li		$t0, 5
	mul		$t0, $t0, $a0	#a = 5a
	li		$t1, 2
	mul		$t1, $a1, $t1	#b = 2b
	li		$t2, 17
	mul		$t2, $t2, $a2	#c = 17c
	sub		$t0, $t0, $t1	# a= a-b
	add		$t0, $t0, $t2	# a = (a-b)+c
	move	$v0, $t0
	jr		$ra


end:
	li		$v0, 10
	syscall