#-----------------------------------------------------------------
#exercise 2
#Benjamin Scown
#62071873
#-----------------------------------------------------------------	
#code section
      .text  		# directive for code section
      .globl main  	# directive: main is visible to other files 
      
main: 
	# register usage
	# $s0 -> value of number to assemble from ascii
	# $s1 -> address for current character in buffer
	# $s2 -> mask
	# $s3 -> final value
	# $t0 -> for loop counter
	# $t1 -> for loop max
	# $t2 -> tempory character 
	
	# promt user to enter value
	li $v0, 4
	la $a0, msg1
	syscall

	# store value entered by user
	li $v0, 8
	la $a0, buffer1
	li $a1, 9 # limits input to 8 characters
	syscall
	
	#convert string in `buffer` to an 8-bit value
	
	and $t0, $t0, $zero # initialize loop counter
	li $t1, 8 # set loop max
	
	la $s1, buffer1 # stores base address of buffer in $s1
	
	addi $s2, $zero, 1 # create mask to hide all bits but the least significant
	
rdchar:
	
	lbu $t2, 0($s1) # load char at pos into $t2
	
	sll $s3, $s3, 1 # shift $s3 to the left once to create space for new char
	and $t2, $t2, $s2 # apply mask
	or $s3, $s3, $t2 # add value to lowest bit of $s3
	
	addi $s1, 1 # increment address of character to read
	addi $t0, 1 # increment loop counter
	bne $t0, $t1, rdchar # restarts loop if counter hasn't reached the target
	
	# print msg2
	li $v0, 4
	la $a0, msg2
	syscall
	
	j tohex # skip the next 2 headers
		
isnum:
	bgt $t0, $t1, isletter
	addu $t0, $t0, 48
	sb $t0, 0($t2) # stores the ascii representation of the value in $t0, offset is 30 to convert to an ascii number
	addi $t2, $t2, 1 # increments the address of the character to store

	jr $ra
	
isletter:
	add $t0, $t0, 55
	sb $t0, 0($t2) # stores the ascii representation of the value in $t0, offset is 61 to convert to lowercase letter
	addi $t2, $t2, 1 # increments the address of the character to store
	
	jr $ra
	
tohex:
	# look at top 4 bits, convert to hex encoded with ascii character
	# $s3 -> unconverted value
	# $t0 -> value to convert to hex encoded in ascii
	# $t1 -> value to check if hex value representation is a number or a letter
	# $t2 -> address of `buffer2`
	
	la $t2, buffer2
	
	li $t1, 9 # store the highest hex value that can be represented with a number 
	
	srl $t0, $s3, 4 # store top four bits of $s3 in $t0
	jal isnum # jump to isnum function and keep return address in $ra
	
	sll $t0, $s3, 28 # remove top 4 bits in $s3 and store in $t0
	srl $t0, $t0, 28 # return bits to lowest position
	jal isnum # jump to isnum function and keep return address in $ra
	
	# print value in `buffer2`
	li $v0, 4
	la $a0, buffer2
	syscall
	
	
	# print ms3
	li $v0, 4
	la $a0, msg3
	syscall
	
	# print value of $s3 as integer
	and $a0, $a0, $zero
	or $a0, $a0, $s3
	li $v0, 1
	syscall

exit:
	li $v0, 10
	syscall

#-------------------------------------------------------------------
#data section

     .data   #directive for

buffer1:
	.space 9
	
	.align 4
	
buffer2:
	.space 2
	
	.align 4
		
msg1:
	.asciiz "Enter your number (0 or 1): "
	
	.align 4
	
msg2:
	.asciiz "\nThe number in base 16 is: 0x"
	
	.align 4
	
msg3:
	.asciiz "\nThe number in base 10 is: "
	
	.align 4
	
	
	
	
	
	
	