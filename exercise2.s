#-----------------------------------------------------------------
#exercise 2
#Benjamin Scown
#62071873
#-----------------------------------------------------------------	
#code section
      .text  		# directive for code section
      .globl main  	# directive: main is visible to other files 
      
main: 

	li $v0, 4
	la $a0, str
	syscall
	
	li $v0, 5
	syscall
	
	# register usage
	# $s0 -> user value
	# $t0 -> loop counter
	# $t1 -> loop max
	# $t2 -> mask to isolate smallest bit
	# $t3 -> temp smallest bit storage
	# $t4 -> adress for numout, gets incremented when a character is added
	
	or $s0, $zero, $v0 # load value that was read into $s0
	addiu $t2, $zero, 1 # create mask 
	
	la $t4, numout # store numout adress
	addiu $t4, $t4, 7 # move adress to end value
	
	# create counter and max for counter
	or $t0, $t0, $zero # clear registers	
	or $t1, $t1, $zero
	
	addiu $t1, $t1, 8
	# a loop that takes the value of the rightmost bit and convert it to ascii, storing each digit in numout 
	
loop:
	and $t3, $s0, $t2 # apply mask
	addi $t3, 48 # convert to ascii
	
	sb $t3, 0($t4) # move ascii-encoded value to numout
	
	addiu $t4, $t4, -1 # decrement adress that points to position in numout
	
	srl $s0, $s0, 1 # move to next bit
	addiu $t0, $t0, 1 # increment counter
	bne $t0, $t1, loop
	

	# print final value
	li $v0, 4
	la $a0, numout
	syscall
	
exit:
	li $v0, 10
	syscall

#-------------------------------------------------------------------
#data section

     .data   #directive for

str:
	.asciiz "Enter your number (base 10): "
	
	.align 4
	
numout:
	.space 8
	
	.align 4