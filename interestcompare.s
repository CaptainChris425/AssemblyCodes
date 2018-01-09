#Christopher Young
#Program 4
#11/2/2017
#---------
#This program compares simple and compounding interest
#on the same loan to show that compounding is higher.

	.data
principal:	.word 10000
time:		.word 10
irate:		.double 0.05
oned:		.double 1.0

Prompt1: 	.asciiz "The compounded interest: " 
Prompt2:	.asciiz "The simple interest: "  

# Constants
precisionval = 5

newline  = '\n'		# Newline


PRINT_INT_SERV    = 1
PRINT_FLOAT_SERV  = 2
PRINT_DOUBLE_SERV = 3 
PRINT_STR_SERV    = 4
PRINT_CHAR_SERV   = 11
TERMINATE_SERV    = 10

	.text
	.globl main

main:
	l.d $f0, irate		#load interest rate		($f0 holds interest rate)
	lw $t0, time		#load the time into $t0 (converting to double)
	mtc1.d $t0, $f2		#move to double register
	cvt.d.w	$f2, $f2	#convert from word to double 	($f2 holds time a double)
	lw $t0, principal	#load the principal payment into $t0 (converting to double)
	mtc1.d $t0, $f4		#move to double register
	cvt.d.w	$f4, $f4	#convert from word to double 	($f4 holds principal a double)

	#--------------------
	#to call exp_int:
	#--------------------
	#$f12 <- interest rate
	#$f14 <- time
	
	mov.d $f12, $f0		#move interest into $f12
	mov.d $f14, $f2		#move time into $f14
	jal exp_int
	
	#$f0 holds compounded interest
	
	#multiply interest ammount by principal payment
	mul.d $f12, $f0, $f4	#total payment in $f12
	
	# Print a message
	la $a0, Prompt1
	li $v0, PRINT_STR_SERV
	syscall

	# Print the result of interest * principal
	li $v0, PRINT_DOUBLE_SERV
	syscall
	
	li $a0, newline			# Print a newline char
	li $v0, PRINT_CHAR_SERV 
	syscall
	
	#-------------------
	#to call simple_int:
	#-------------------
	#$f12 <- interest rate
	#$f14 <- years

	l.d $f0, irate		#load interest rate		($f0 holds interest rate)
	mov.d $f12, $f0		#move interest into $f12
	mov.d $f14, $f2		#move time into $f14

	jal simple_int
	
	#$f0 holds simple interest
	#multiply interest ammount by principal payment
	mul.d $f12, $f0, $f4	#total payment in $f12
	
	# Print a message
	la $a0, Prompt2
	li $v0, PRINT_STR_SERV
	syscall

	# Print the result of interest * principal
	li $v0, PRINT_DOUBLE_SERV
	syscall

	li $v0, TERMINATE_SERV
	syscall
	#terminate

exp_int:
	#------------------------
	#Calculates the cumulative interest rate of ,1, unit of currency
	#over a ,t, unit of time using a ,r, interest rate
	#evaluating e^x as sum(0,precisionval) : (x^i)/(i!)
	#Prototype: int exp_int(int interestrate, int time)
	#Parameters:
	#$f12 <- interest rate				(r)
	#$f14 <- years					(t)
	#Registers used:			doubles:
	#$f6 <-	interest*time, x value 			(x)
	#$f8 <- numerator value 			(n)
	#$f10 <- d as a float & the quotient of n/d 	(dd)
	#					ints:
	#$t0 <- loop counter 				(i)
	#$t1 <- denominator as int 			(d)
	#$t2 <- exponent count 				(e)
	#Returns:
	#f0 <- simple interest = 1+r*t			(s)
	#------------------------
	
	mul.d $f6, $f12, $f14	#stores i*t into x [$f6]
	l.d $f0, oned		#initialize s to 1 [$f0]
	mov.d $f8, $f6		#copy x into n [$f8]
	add $t0, $0, $0		#intialize i to 0 [$t0]
	add $t1, $0, $0		#initialize d to 1 [$t1]
	addi $t1, 1
loop1:
	addi $t0, 1		#i++
	add $t2, $0, $t0	#initialize e to i [$t2]
	bgt $t0,  precisionval, endloop1#end opp if i > precision
exponent:
	ble $t2, 1, exponentend	#end loop when e <= 1
	mul.d $f8, $f8, $f6	#n = n * x
	addi $t2, $t2, -1	#e = e - 1
	b exponent
exponentend:
	mul $t1, $t1, $t0	#d = d * i ; d!
	mtc1.d $t1, $f10	#move d to double register
	cvt.d.w	$f10, $f10	#convert d from word to double
	div.d $f10, $f8, $f10	#$f10 = n/d 
	add.d $f0, $f0, $f10	#s = s +(n/d)
	b loop1
endloop1:
	jr $ra

simple_int:
	#------------------------
	#Calculates simple intrest using formula (1-r*t)
	#Prototype: int simple_int(int interestrate, int time)
	#Parameters:
	#$f12 <- interest rate
	#$f14 <- years
	#registers used:
	#$f6
	#$f8
	#Returns:
	#f0 <- simple interest (1+r*t)
	#------------------------
	mov.d $f6, $f12
	mov.d $f8, $f14
	mul.d $f0, $f6, $f8
	l.d $f6, oned
	add.d $f0, $f0, $f6
	jr $ra
