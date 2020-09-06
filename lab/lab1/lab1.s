main:   addi $8, $0, 0
		addi $9, $0, 1
		addi $10, $0, 26
		j action
		j exit
action: add $8, $8, $9 
		addi $9, $9, 1
		bne $9, $10, action
		j exit
exit:	addi $15, $0, 15
		jr $ra
		