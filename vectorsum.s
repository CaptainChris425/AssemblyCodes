#Christopher Young - Extra Credit
#This program uses a subroutine that computes the sum of elements of 2 arrays of integers.
#and stores the new vector in dynamic memory
#Then uses another subroutine to print out the the new array 
 


		.data
Sum_str:	.asciiz "Sum of the array elements: "
		
Array1:		.word 5, 10, 15, 20, 25, 30, 4
Array1end:	.space 1
Array2:		.word 6, 4, 13, 7, 9, 5, 5
Array2end:	.space 1


# Constants
one = 1
PRINT_INT_SERV = 1
PRINT_STR_SERV = 4
TERMINATE_SERV = 10
PRINT_CHAR_SERV = 11
Comma= ','


	.text
	.globl  main
main:
	la $a0, Array1		#load start ($a0) and 
	la $a1, Array1end	#end of array ($a1)
	sub $a1, $a1, $a0	#find difference in bits
	sra $a1, $a1, 2 	#Count the elements by /4 and store in ($a1)
	la $a2, Array2		#load start ($a2) and
	la $a3, Array2end	#end of array ($a3)
	sub $a3, $a3, $a2	#find difference in bits
	sra $a3, $a3, 2 	#Count the elements by /4 and store in($a3)

	move $t0, $0
	sll $t0, $a1, 2		#multiply by 4 for number of bits
	move $a0, $t0
	li $v0, 9
	syscall
	move $a3, $v0		#location for alocated memory for destarray ($a3)

	
	la $a0, Array1		#load start array1 back into ($a0)	
	##Before call to sum vectors
	#a0 <- A1 start
	#a1 <- A1 num elements
	#a2 <- A2 start
	#a3 <- Adest start

	jal sumvectors
	
	move $a0, $a3
	#$a0 <- location arrray
	#$a1 <- number of elements

	jal printarray
	
	li $v0, TERMINATE_SERV  # terminate program
     	syscall
.end main

####################################
#Prototype: void sumvectors(int * array1, int arraycount, 
#				int* array2, int array3dest)
#Parameters:
#a0 <- A1 start
#a1 <- A1 num elements
#a2 <- A2 start
#a3 <- A3 dest start
#Stores 3rd array in the A3 dest
####################################
sumvectors:
	move $t0, $0	#start loop counter ($t0)

Loop:		#Loop break if counter is greater than elements
	lw $t1, ($a0)		#store element of array1 ($s2)
	lw $t2, ($a2)		#store element of array2 ($s3)
	move $t3, $0
	add $t3, $t1, $t2	#get sum for each value into ($t3)
	sw $t3, ($a3)	#store sum ($t3) on dynamic memory
	addi $a0, $a0, 4	#increment A1 increment 
	addi $a2, $a2, 4	#increment A2 increment
	addi $a3, $a3, 4	#increment A3 increment
	addi $t0, $t0, 1 	#index loop counter
	#loop condition
	blt $t0, $a1, Loop	#bridge if the count < num elements

	jr $ra


######################################
#Prototype: void printarray(int array)
#
#Parameters:
#$a0 <- location of array to print
#$a1 <- num of elements
#Prints array values
#######################################
printarray:
	move $t0, $0 	#loop counter ($t0)
	move $t1, $a1
	move $a1, $a0		#memory adress in ($a1)
	#addi $a1, $a1, -4
correctadress:
	bgt $t0, $t1, else
	addi $a1, $a1, -4
	addi $t0, $t0, 1
	b correctadress
else:
	move $t0, $0 	#loop counter ($t0)
	addi $a1, $a1, 4
Loop2:
	lw $a0, ($a1)		#store array elem
	li $v0, PRINT_INT_SERV		#print length
	syscall
	li $a0, Comma			# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall
	addi $a1, $a1, 4		
	addi $t0, $t0, 1		#increment count
	blt $t0, $t1, Loop2
	
	jr $ra
	
