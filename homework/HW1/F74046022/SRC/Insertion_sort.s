.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7 # you can change the element of array

.text
main:
	addi $t0, $zero, 4097      # $t0 = 0x00001001
	sll  $t0, $t0, 16          # set the base address of your array into $t0 = 0x10010000    

	#--------------------------------------#
	#  \^o^/   Write your code here~  \^o^/#
	#--------------------------------------#
	add  $s0, $t0, $zero;	
	addi $s1, $s0, 40;
	jal  Sort;
    
	li   $v0, 10               # program stop
	syscall
	
Sort:	
	add  $t1, $s0, $zero;
	bne	 $t1, $s1, Next;
	
Next:
	addi $t1, $t1, 4;
	addi $t0, $t1, 4;
	bne	 $t1, $s1, Scan;
	jr	 $ra;
	
Scan:
	addi $t0, $t0, -4;
	beq  $t0, $s0, Next;
	j 	 CheckSwap;
	
CheckSwap:
	lw   $t8, -4($t0);
	lw	 $t9, ($t0);
	slt	 $t7, $t8, $t9;
	bne	 $t7, $zero, Next;
	sw	 $t8, ($t0);
	sw	 $t9, -4($t0);
	j 	 Scan;
	