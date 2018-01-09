#Christopher Young
#Program Assignment #1 Date: 10-10-2017
#This program sums up an array and outputs the smallest and the largest number in the array
		


	.globl main
		.data
#Constants
newline = '\n'
minis: .asciiz "Min is: "	#to print min is
maxis: .asciiz "Max is: "	#to print max is

# System service constants
PRINT_INT_SERV = 1
PRINT_CHAR_SERV = 11
TERMINATE_SERV = 10
PRINT_STR_SERV  = 4
	  	
array:    	.word   5, 10 , 15, 206, 25, 28, 24, 1, 14, 3
arrayEnd: 	.space 1

		.text
main:
	la $t1, arrayEnd	#store end of array
	la $a0, array		#stores location of array ($a0)
	subu $t0, $t1, $a0	#find the differenced is bytes between array($t0) and array end($t1)
	srl $a1, $t0, 2		#shift over two bytes 
				#same as dividing by 4
				#$a1 = number of elements in array
	jal MaxMin
	add $t1, $v1, $0	#trying to move v1 to t1 and v0 to t0
	add $t0, $v0, $0	#max in ($t0) min in ($t1)
	la $a0, maxis		#Print out "Max is: "
	li $v0, PRINT_STR_SERV
	syscall
	move $a0, $t0		#Prints out the max value
	li $v0, PRINT_INT_SERV
	syscall
	li $a0, newline		# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall
	la $a0, minis		#Print out "Min is: "
	li $v0, PRINT_STR_SERV
	syscall
	move $a0, $t1		#Prints out the min value
	li $v0, PRINT_INT_SERV
	syscall
	li $v0, TERMINATE_SERV  # terminate program
     	syscall

#MaxMin- finds max and min numbers of an array 
# Prototype : MaxMin(int arraystartloc, int numberofelements);
#Parameters:
#	$a1 numberofelements
#	$a0 arraystartloc
#Returns max in $v0 and min in $v1
#

MaxMin:
	add $t1, $0, $0		#$t1 = loop counter
	add $t2, $0, $0		#$t2 = offset varible to move
				#through the array
	lw $t3, array($t2)
	add $v0, $0, $t3	#starts the max at element 0 ($v0)
	add $v1, $0, $t3	#starts the min at element 0 ($v1)

Loop:
	bge $t1, $a1, Done	#if loop counter is bigger than
				#elements in array then branch to Done(Finishing loop)
	lw $t3, array($t2)	#Load element at increment into $t3
	bge $t3, $v0, max	#if the element($t3) is greater than the max($v0) bridge to max
	ble $t3, $v1, min	#if the element($t3) is less than the min($v1) bridge to max
	b else
max:
	move $v0, $t3
	b else
min:
	move $v1, $t3
else:
	addiu $t1, $t1, 1	# Increment loop counter
	addiu $t2, $t2, 4	# Increment offset to get to the next word
	b Loop
Done:
	jr $ra











