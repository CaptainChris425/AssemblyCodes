#Christopher Young
#This programming assignment will output the length of a string as well
#as the number of upper case, lower case, and decimal numbers contained
#10/17/17


	.data
#constants
PRINT_INT_SERV = 1
PRINT_CHAR_SERV = 11
TERMINATE_SERV = 10
PRINT_STR_SERV  = 4
NULL = 0
LL = 97
LH = 122
UL = 65
UH = 90 
DL = 48
DH = 57
newline = '\n'
lenis : .asciiz "Length is: "		#to print Length is
upis : .asciiz "Uppercase Count: "	#to print upper count 
lowis : .asciiz "Lowercase Count: "	#to print lower count 
decis : .asciiz "Decimal Count: "	#to print decimal count 

Str:  .ascii  "MIPS is a reduced instruction set computer (RISC) " 
      .ascii  "instruction set architecture (ISA) developed by MIPS Technologies " 
      .ascii  "(formerly MIPS Computer Systems). The early MIPS architectures "
      .ascii  "were 32-bit, with 64-bit versions added later. There are multiple "
      .ascii  "versions of MIPS: including MIPS I, II, III, IV, and V; as well as five " 
      .ascii  "releases of MIPS32/64 (for 32- and 64-bit implementations, "
      .ascii  "respectively). As of April 2017, the current version is MIPS32/64 "
      .ascii  "Release 6. MIPS32/64 primarily differs from MIPS I–V by defining "
      .ascii  "the privileged kernel mode System Control Coprocessor "
      .asciiz "in addition to the user mode architecture."


	.text
	.globl main
main :
	la $a0, Str

	jal StrLen			#call StrLen
	add $s0, $v0, $0		#store string length in ($s0)
	
	la $a0, lenis			#Print out "Length is: "
	li $v0, PRINT_STR_SERV
	syscall

	move $a0, $s0			#store string length
	li $v0, PRINT_INT_SERV		#print length
	syscall

	li $a0, newline			# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall	

	addiu $sp, $sp, -12		#allocate room on the stack for 3 pieces (4bit)
	la $a0, Str			#load string into $a0
	move $a1, $s0			#load length into $a1
	jal charCategory		#call charCategory
	
	la $a0, decis			#Print out "Decimal count: "
	li $v0, PRINT_STR_SERV
	syscall

	lw $a1, ($sp)			#store decimal count
	move $a0, $a1
	li $v0, PRINT_INT_SERV		#print decimal count
	syscall

	li $a0, newline			# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall

	la $a0, upis			#Print out "Uppercase count: "
	li $v0, PRINT_STR_SERV
	syscall

	lw $a1, 4($sp)			#store uppercase count
	move $a0, $a1
	li $v0, PRINT_INT_SERV		#print uppercase count
	syscall

	li $a0, newline			# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall
	
	la $a0, lowis			#Print out "Lowercase count: "
	li $v0, PRINT_STR_SERV
	syscall

	lw $a1, 8($sp)			#store lowercase count
	move $a0, $a1
	li $v0, PRINT_INT_SERV		#print lowercase count
	syscall

	addiu $sp, $sp, 12
	li $v0, TERMINATE_SERV  	# terminate program
     	syscall




########################
#Calculated the length of a string through iteration
#Parameters:
#$a0 <- location of string object
#Returns:
#$v0 <- String length
######################## 
StrLen:
	add $t0, $0, $0		#initialize loop to 0 ($t0)

Loop:				#start loop
	lb $t1, ($a0)		#load char of string to ($t1)
	beq $t1,NULL,Done	#condition if the character is NULL (ascii 0)
	addi $t0, 1 		#increment count
	addi $a0, $a0, 1	#increment itteration
	
	b Loop
Done:
	move $v0, $t0		#store string length in $v0
	jr $ra

########################
#Iterate a string to count how many:
# * Uppercase, Lowercase, and Numeric characters
#Parameters:
#$a0 <- Location of string object
#$a1 <- Length of string
#Returns on the stack:
# Uppercase count
# Lowercase count
# Decimal count
##########################
charCategory:
	add $t0, $0, $0		#initialize loop to 0 ($t0)
	add $t1, $a1, $0	#length of string ($t1)

	add $t3, $0, $0		#Lowercase counter ($t3)
	add $t4, $0, $0		#Uppercase counter ($t4)
	add $t5, $0, $0		#Decimal counter ($t5)

Loop2:				#in loop2
	beq $t0, $t1, Done2		#bridge when the loop counter equals the length of str
	lb $t2, ($a0)			#load char of string ($t2)
	blt $t2, LL, Lowercaseelse	#if it is <LL it is not lowercase
	blt $t2, LH, Lowercase		#if it is >LL and <LH it is
Lowercaseelse:
	blt $t2, UL, Uppercaseelse	#if it is <UL it is not uppercase
	blt $t2, UH, Uppercase		#if it is >UL and <UH it is
Uppercaseelse:
	blt $t2, DL, else		#if it is <DL it is not Decimal
	blt $t2, DH, Decimal		#if it is >DL and <DH it is
else:					#returns to loop condition
	addi $t0, 1		#increment counter
	addi $a0, $a0, 1	#increment itteration
	b Loop2


Lowercase:			#in Lowercase
	addi $t3, $t3, 1		#increment Lowercase count by 1
	b else				#return to loop2 condition
Uppercase:			#in Uppercase
	addiu $t4, $t4, 1		#increment Uppercase count by 1
	b else				#return to loop2 condition
Decimal:			#in Decimal
	addiu $t5, $t5, 1		#increment Decimal count by 1
	b else				#return to loop2 condition


Done2:
	sw $t3, 8($sp)		#lowercase on stack	top
	sw $t4, 4($sp)		#uppercase on stack	mid
	sw $t5, ($sp)		#decimal on stack	bot
	jr $ra
	
