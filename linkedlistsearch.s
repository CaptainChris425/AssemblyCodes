#Christopher Young
#11/21/2017
#This program dearches a linked list
#for a value and returns index of node

NULL = 0
NL = '\n'	

PRINT_INT_SERV  = 1
PRINT_STR_SERV  = 4
TERMINATE_SERV	= 10
PRINT_CHAR_SERV = 11
READ_INT_SERV = 5

        .data
whatval:	.asciiz "What value would you like to find(0 to exit) : "
nf:		.asciiz "!value not found in list!"
head:
node01: .word 1
  	.word 2
        .word node02
node02: .word 2
  	.word 3
        .word node03
node03: .word 3
  	.word 5
        .word node04
node04: .word 4
  	.word 7
        .word node05
node05: .word 5
	.word 11
        .word node06
node06: .word 6
  	.word 13
        .word node07
node07: .word 7
  	.word 17
        .word node08
node08: .word 8
  	.word 19
        .word node09
node09: .word 9
	.word 23
        .word node10
node10: .word 10
  	.word 29
        .word NULL
	
	.text
main:
loop:
	la $a0, NL		#Newline
	li $v0, PRINT_CHAR_SERV
	syscall
	la $a0, whatval		#asking for value to find
	li $v0, PRINT_STR_SERV
	syscall
	li $v0, READ_INT_SERV
	syscall
	add $a1, $0, $v0	#store value in $a1
	beq $a1, $0, endprog	#if val = NULL(0)
	la $a0, head		#load address of head node in $a0
	jal Searchlist		#call searh on linked list
				#$a0 = head, $a1 = value
	move $a0, $v0		#store index in $a0
	beq $a0, 0, notfound
	li $v0, PRINT_INT_SERV	#print index
	syscall
	b loop	
notfound:
	la $a0, nf		#not found in list
	li $v0, PRINT_STR_SERV
	syscall
	b loop
endprog:
	li $v0, 10  # terminate program
 	syscall




#Linked List Search
#Prototype : int search(Node* head, int value)
##Registers used
#$a0 <- head
#$a1 <- value
#$s0 <- curr
#$t1,2 <- curr.next,value
##Returns:
#$v0 <- index of list
Searchlist:
	move $s0, $a0	#$s0 = curr(head)
Searchloop:
	lw $t0, 8($s0)	#$t0 = curr.next
	lw $t1, 4($s0)	#$t1 = curr.val
	beq $t1, $a1, Searchfound
	move $s0, $t0	#curr = curr.next
	bne $s0, $0, Searchloop	#if curr.next != NULL, loop
	move $v0, $0	#if not found return 0
	jr $ra
Searchfound:
	lw $v0, 0($s0)
	jr $ra

