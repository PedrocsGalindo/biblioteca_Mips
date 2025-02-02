.data
	local_livros : .asciiz "C:/Users/luism/Desktop/projeto_Assembly/lista_livros"
	msg: .asciiz "ACERVO:"
	msgFim: .asciiz  "---------------------------------------------"
	bufferLinha: .align 2 
		     .space 68 
	byte: .align 2
	      .space 1
.text


	listarLivros: 
		la $a0, msg
		li $v0, 4
		syscall
		
		la $a0, local_livros
		jal abrirArquivoLeitura
		jal lerArquivoLinha
		li $v0, 4
		la $a0, bufferLinha
		syscall 
		li $v0 , 16
		syscall
		
	abrirArquivoLeitura:
		#$a0 deve conter o caminho do arqui
		li $v0, 13
		li $a1, 0
		syscall
		
		move $s0, $v0
		jr $ra
		 
	lerArquivoLinha:
		move $a0, $s0
		li $t2, 0x0A
		li $t3, 0 #variável para iterar sobre o bufferLinha
		
		loopleitura:
			beq $t1, $t2, finalizar # -> Se $t1 for igual a $t2, desvia para "finalizar"
			la $a1, byte
			li $a2,1
			li $v0, 14
			syscall 
			lb $t1, byte #load byte para o registrador $t1
			sb $t1, bufferLinha($t3)
			addi $t3, $t3, 1
			j loopleitura
			 
		finalizar: 
			la $a0, msgFim
			li $v0, 4
			syscall
			jr $ra 
			 
			 
			 
			 
			 