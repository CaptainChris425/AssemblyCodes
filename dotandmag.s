#Christopher Young
#Program 5
#11/7/2017
#---------
#This program calculates the magnitude
#and the dot product of 2 vectors
#----------

	.data
vec1:	.double 1.0,1.0,1.0
vec2:	.double 1.0,1.0,-1.0
Mag1:	.double 0.0
Mag2:	.double 0.0 
Dotp:	.double 0.0
ZERO:	.double 0.0

#constants
PRINT_INT_SERV    = 1
PRINT_DOUBLE_SERV = 3 
PRINT_STR_SERV    = 4
PRINT_CHAR_SERV   = 11
TERMINATE_SERV    = 10

ELEMENT_SIZE = 8
VEC_SIZE = 3

	.text
	.globl main

main:
	la $a1, vec1
	la $a2, vec2
	sw $a1, 0($sp)	#address of vec1 on 0($sp)
	sw $a2, 4($sp)	#address of vec2 on 4($sp)
	jal dot_prod

	la $t0, Dotp
	l.d $f0, 8($sp) 
	s.d $f0, ($t0)	#Stores the value of dot prod into label Dotp


	la $a1, vec1
	sw $a1, 0($sp)	#address of vec1 on 0($sp)
	jal magnitude

	la $t0, Mag1
	l.d $f0, 4($sp)
	s.d $f0, ($t0)	#Stores the value of Magnitude1 into label Mag1

	la $a1, vec2
	sw $a1, 0($sp)	#address of vec1 on 0($sp)
	jal magnitude

	la $t0, Mag2
	l.d $f0, 4($sp)
	s.d $f0, ($t0)	#Stores the value of Magnitude2 into label Mag2


	l.d $f0, Dotp	#dot prod for numerator in $f0
	l.d $f2, Mag1	#mag1 in $f2
	l.d $f4, Mag2	#mag2 in $f4

	mul.d $f2, $f2, $f4 #multiply the magnitudes
	div.d $f0, $f0, $f2 #divide dot prod by mag1*mag2

	mov.d $f12, $f0	#move inverse cosign of angle into $f12
	li $v0, PRINT_DOUBLE_SERV
	syscall

	li $v0, TERMINATE_SERV  # terminate program
     	syscall





# dot_prod subroutine -- Calculate the dot product of two vectors.
# Prototype: void dot_prod(double * vec1, double * vec2, double * result);
# Parameters:
#   vec1 - integer address of vec1, passed on stack at 0($sp)
#   vec2 - integer address of vec2, passed on stack at 4($sp)
#   result - integer address of dot product result, returned on stack at 8($sp)

# On exit, the routine modifies the memory pointed to by 8($sp)
# Registers used:
#  $t0 - loop counter
#  $t1 - current offset in 1st vector
#  $t2 - current offset in 2nd vector
#  $f0 - element (double) from 1st vector
#  $f2 - element (double) from 2nd vector
#  $f4 - accumulated sum (double)

dot_prod: 
    move $t0, $0  # Initialize loop counter
    l.d $f4, ZERO  # Initialize accumulated sum
    lw $t1, ($sp)  # load $a0 with address of 1st vector
    lw $t2, 4($sp)  # load $a1 with address of 2nd vector 
 
LoopDP: 
    l.d $f0, ($t1)
    l.d $f2, ($t2)
    mul.d $f2, $f0, $f2 # $f2 = $f0 * $f2
    add.d $f4, $f4, $f2 # $f4 = $f4 * $f2
    addi $t1, $t1, ELEMENT_SIZE  # Increment $t1 and $t2 by size of a double
    addi $t2, $t2, ELEMENT_SIZE
    addi $t0, $t0, 1    # Increment loop counter
    blt $t0, VEC_SIZE, LoopDP
 
    la $t0, 8($sp)      # Load $t0 with address on stack
    # ($t0 is not needed any more as loop counter)
 
    s.d $f4, ($t0)      # Store $f4 at location pointed to by $t0 
  
    jr $ra              # return to main
.end dot_prod


#Magnitude subroutine
#Prototype: double magnitude(double* vec)
#Parameters:
#vec <- passed in on stack 0($sp)
#result <- returned on stack 4($sp)
#registers used:
#f0 <- current element
#f2 <- sum of square elements
#t0 <- loop counter
#t1 <- current offset in vector
#returns:
#magnitude of vector on 4($sp)
#############
magnitude:
	move $t0, $0 		# Initialize loop counter
	l.d $f2, ZERO  		# Initialize accumulated sum
	lw $t1, ($sp)  		# load $a0 with address of 1st vector
LoopMag:
	l.d $f0, ($t1)		#load element
	mul.d $f0, $f0, $f0 	#f0 = f0*f0
	add.d $f2, $f2, $f0	#add square element to sum
	addi $t0, $t0 , 1	#incriment loop counter
	blt $t0, VEC_SIZE, LoopMag
	
	sqrt.d $f2, $f2
	la $t0, 4($sp)      # Load $t0 with address on stack

    	s.d $f2, ($t0)      # Store $f2 at location pointed to by $t0 
	
	jr $ra
.end magnitude
	
	

	
	
