#Christopher Young
#11/21/2017
#This program sums either a row or a column
#in a 2d array based off user imput as to which
#row/col to sum


NUM_ROWS = 5
NL = '\n'	

PRINT_INT_SERV  = 1
PRINT_STR_SERV  = 4
TERMINATE_SERV	= 10
PRINT_CHAR_SERV = 11
READ_INT_SERV = 5

	.data
whichrow:	.asciiz "Which row or column?: "
colorrow:	.asciiz "Are we summing a row(0) or column(1)? : "
sumis:		.asciiz "Sum is: "

row0: .word 1, 2, 3, 4, 5
row1: .word 2, 4, 6, 8 , 10
row2: .word 3, 6, 9, 12, 15
row3: .word 4, 8, 12, 16 ,20
row4: .word 5, 10, 15, 20, 25
Array: .word row0, row1, row2, row3, row4	# The addresses of the row_n arrays
stride: .word row1 - row0			# Length in bytes of each row

	.text
main:
	
	
	la $a0, colorrow	#asking 0 for row and 1 for col
	li $v0, 4
	syscall
	li $v0, READ_INT_SERV
	syscall
	add $a1, $0, $v0	#store row/col 0/1 in $a1

	la $a0, whichrow	#asking which row or colum
	li $v0, 4
	syscall

	li $v0, READ_INT_SERV
	syscall
	add $a2, $0, $v0	#store row/col num in $a2

	li $a3, NUM_ROWS
	la $a0, Array		#Adress of array stored in $a1	
	jal RowOrColumnSum
	move $s1, $v0	

	la $a0, sumis		#displaying sum
	li $v0, 4
	syscall
	move $a0, $s1
	li $v0, PRINT_INT_SERV
	syscall	


	li $v0, 10  # terminate program
 	syscall


#RowOrColumnSum:
##
#Prototype : int rocs(int* array, int roc, int spot, int rownum)
#Registers used:
#$a0 <- Adress of array
#$a1 <- Row or col ( 0 or 1)
#$a2 <- row/col number to sum
#$a3 <- number of rows
## Returns:
#$v0 <- sum of row or col
RowOrColumnSum:
	blt $a2, $0, end
	bge $a2, $a3, end	#if the row doesnt exist
	move $t0, $0	#loop counter 
	move $s0, $a0	#save adress of array
	move $t2, $0		#init sum to 0
	beq $a1, 0, rowsum	#if 0 sum a row
	beq $a1, 1, colsum	#if 1 sum a col
	b end

### summing row ###
rowsum:
	bge $t0, $a2, rowsumend	#if counter is = row we want
	addi $s0, $s0, 4		#go to next row
	addi $t0, $t0, 1		#increment loop
	b rowsum
rowsumend:
	move $t0, $0		#loop counter
	move $t1, $0		#init sum to 0
	lw $s1, ($s0)		#load address of row
rowloop2:
	bge $t0, $a3, rowsumend2
	lw $t2, ($s1)		#get value at address
	add $t1, $t1, $t2	#add to sum
	addi $t0, $t0, 1	#increment loop
	addi $s1, $s1, 4	#go to next element
	b rowloop2
rowsumend2:
	move $v0, $t1
	jr $ra

### summing col ###
colsum:
	beq $t0, $a3, colsumend	#if gone through all rows
	move $t1, $0		#col loop to 0

	lw $s1, ($s0)		#load adress of row
findcol:
	beq $t1, $a2, findcolend		#on the col
	addi $s1, $s1, 4	#go to next element
	addi $t1, $t1, 1	#increment loop
	b findcol
findcolend:
	lw $t3, ($s1)
	add $t2, $t2, $t3	#add element to sum
	addi $s0, $s0, 4	#go to next row
	addi $t0, $t0, 1	#increment loop
	b colsum
colsumend:
	move $v0, $t2		#return sum
	jr $ra
end:	
	move $v0, $0
	jr $ra
	






