.data
	booksFile : .asciiz "C:/Users/luism/Desktop/projeto_Assembly/lista_livros.txt"
	local_temp: .asciiz "C:/Users/luism/Desktop/projeto_Assembly/temp.txt"
	msgSucesso: .asciiz "Arquivo limpo com sucesso!\n"
	msgAcervo: .asciiz "ACERVO: \n"
	msgISBN: .asciiz "ISBN:"
	msgLivroApagado: .asciiz "\nRegistro do livro apagado!"
	msgFim: .asciiz  "\n---------------------------------------------"
	bufferLivro: .align 0 
		     .space 70 
	byte: .align 0
	      .space 1
	bufferISBN: .align 0
		    .space 14
.text	
	main:
	jal removerRegistroLivro
	 

	listarLivros:  # função para listar os livros do ACERVO
		la $a0, msgAcervo
		li $v0, 4
		syscall # imprima a mensgem ACERVO
		la $a0, local_livros
		jal abrirArquivoLeitura
		
		loopListarLivros: # loop que irá printar printar pegar uma linha, printar e depois limpar o buffer até não existirem mais registros no arquivo
			jal lerArquivoLinhaLivro 
			jal printarLinhaLivro
			jal limparBufferLinhaLivro
			beqz $s1,finalizarloopListarLivros
			j loopListarLivros
		finalizarloopListarLivros: # função para finalizar
			la $a0, msgFim 
			li $v0, 4
			syscall
			li $v0, 16 #fecha o arquivo
			syscall
			j main # volta para a MAIN
		
	
#abre o arquivo passado em $a0 no modo leitura		
abrirArquivoLeitura:
	#$a0 deve conter o caminho do arquivo
	li $v0, 13
	li $a1, 0
	syscall
	move $s0, $v0
	jr $ra
	
#abre o arquivo passado em $a0 no modo escrita		
abrirArquivoEscrita:
	
	li $v0,13
	li $a1, 1
	syscall 
	move $s5, $v0
	jr $ra

#fecha o arquivo cujo descritor estiver salvo em $a0	
fecharArquivo:
	li $v0, 16
	syscall
	jr $ra
	
		 
lerArquivoLinhaLivro:
	# O Descritor do arquivo deve estar em $s0
	move $a0, $s0 # passa o descritor para $a0
	li $t2, 0x0A # character que representa a quebra de linha
	li $t3, 0 #variável para iterar sobre o bufferLinha
		
	loopLeitura: #irá ler byte a byte do arquivo e incrimentar no bufferLinha até encontrar uma quebra de linha
		la $a1, byte 
		li $a2,1
		li $v0, 14
		syscall # lê um byte do arquivo
		lb $t1, byte #load byte para o registrador $t1
		beqz $v0, finalizarLerArquivoLinha #se o arquivo já foi totalmente lido
		sb $t1, bufferLivro($t3) #incrementa o byte no buffer
		addi $t3, $t3, 1 # incrementa 1 a variável de iteração
		beq $t1, $t2, finalizarLerArquivoLinha # -> Se $t1 for igual a $t2, significa que ele encontrou a quebra de linha e desvia para "finalizar"
		j loopLeitura
	finalizarLerArquivoLinha:
		move $s1, $v0
		jr $ra
			 
printarLinhaLivro: 
	li $v0, 4
	la $a0, bufferLivro
	syscall
	jr $ra
			
		
#limpa o que estiver contido em buffer linha			
limparBufferLinhaLivro:
	li $t0, 0 #variavelde ireração
	li $t1, 70 # numero de characteres a serem limpos
	li $t2,0x00 # representa o null
	loopLimparBufferLinhaLivro: 
		beq $t0,$t1,finalizarLoopLimparBufferLinhaLivro # se já tiverem sido apagados todos os registros ele finaliza
		sb $t2,bufferLivro($t0) # aapga o character
		addi $t0, $t0, 1 #incrementa 1 a variável de iteração
		j loopLimparBufferLinhaLivro 
	finalizarLoopLimparBufferLinhaLivro :
		jr $ra
		
#função para truncar todos os registros			
LimpaArquivo:
    la $a0, local_livros      # Carrega o caminho do arquivo
    li $v0, 13                # Syscall para abrir arquivo
    li $a1, 1              # Flags: 1 (O_WRONLY) | 512 (O_TRUNC)               # Não usa permissão extra
    syscall                   # Realiza a syscall para abrir o arquivo


    # Fechar o arquivo
    li $v0, 16                # Syscall para fechar arquivo
    move $a0, $s0             # Passa o descritor do arquivo
    syscall                   # Realiza a syscall para fechar o arquivo

    # Exibir mensagem de sucesso
    li $v0, 4
    la $a0, msgSucesso
    syscall

    # Finalizar o programa
    li $v0, 10
    syscall
    
    
removerRegistroLivro: 
	#abrindo o arquivo de livros
	la, $a0, local_livros
	jal abrirArquivoLeitura
	#s0 contém o descitor de local_livros
	la, $a0, local_temp
	jal abrirArquivoEscrita
	#s5 contém o descritor de local_temp
	#imprimindo mensagem do ISBN
	li $v0, 4
	la $a0, msgISBN
	syscall 
	#pegando o ISBN do usuario
	li $v0,8
	la $a0, bufferISBN
	li $a1,14
	syscall
	#fechando os arquivos
	
	
	#Esse loop transfere linha por linha do arquivo de Acervo, e transfere para o arquivo temporario, exceto a linha que eu quero apagar
	loopTransferirRegistroLivroTemp:
		jal procurarLivro # procura o livro 
		li $t2, -1
		li $t1, 1
		beq $v0, $t2, finalizarloopTransferirRegistroLivro # se $t2 for -1 significa que todo o arquivo já foi lido
		beq $v0, $t1,loopTransferirRegistroLivroTemp # se ele encontrou o registro a ser apagado ele continua no loop
		beq $v0, $zero, escreverLivroArquivoTemp # se ele não encontrou o registro que deve ser apagado ele escreve no arquivo temporário

	finalizarloopTransferirRegistroLivro:
	# Fecha os arquivos
		move $a0,$s0
		jal fecharArquivo
		move $a0, $s5
		jal fecharArquivo
		
	# abre os arquivos para passar do temporario para o original
		la $a0, local_livros
		jal abrirArquivoEscrita 
		la $a0, local_temp
		jal abrirArquivoLeitura
		
		j loopTransferirRegistroLivro
		
	#escreve o que estiver contido em bufferLivro no arquivo temporário	
	escreverLivroArquivoTemp:
		jal contarCharacteresLinhaLivro #conta o tamanho de characteres passados para BufferLivro
		move $t0,$v0 # move a quantidade passada para $t0
		addi $t0,$t0, 1
		li $v0, 15
		move $a0, $s5 # $s5 deve conter o descritor do arquivo temporario no modo escrita
		la $a1, bufferLivro #escreve o que estiver contido em bufferLivro
		move $a2, $t0 
		syscall
		jal limparBufferLinhaLivro
		j loopTransferirRegistroLivroTemp
		
		
	#loop para repassar os registros do arquivo temporário para o original
	loopTransferirRegistroLivro:
		jal lerArquivoLinhaLivro
		beqz $s1, finalizarloopTransferirRegistroTemp
		jal escreverLivroArquivoLivro
	#escreve no arquivo original
	escreverLivroArquivoLivro:
		jal contarCharacteresLinhaLivro	
		move $t0, $v0
		addi $t0,$t0, 1
		li $v0, 15
		move $a0, $s5
		la $a1, bufferLivro
		move $a2, $t0
		syscall
		jal limparBufferLinhaLivro
		j loopTransferirRegistroLivro
	#finaliza o loop	
	finalizarloopTransferirRegistroTemp:
		# Fecha os arquivos
		move $a0,$s0
		jal fecharArquivo
		move $a0, $s5
		jal fecharArquivo
		#mensagem de arquivo apagado
		la $a0, msgLivroApagado
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
		
		
# conta a quantidade de characteres do bufferLinha e retorna até o indice antes da quebra de linha	
contarCharacteresLinhaLivro: 
	li $t0, 0 # registrador de iteração
	li $t1, 0x0A # character que representa a quebra de linha
	loopContarCharacteresLinhaLivro:
		lb $t2, bufferLivro($t0) #passa o character para $t2
		beq $t2,$t1,finalizarloopContarCharacteresLinhaLivro # se encontrar a quebra de linha ele finaliza a contagem
		addi $t0,$t0,1 #incrementa 1 a variável de iteração
		j loopContarCharacteresLinhaLivro
	finalizarloopContarCharacteresLinhaLivro:
		move $v0,$t0 
		jr $ra
		
# essa função ela pega uma registro de livro, compara se esse registro contém o ISBN que foi inserido pelo usuário, se contém ele retorna 1, se não contém ele retorna 0.
# E se o arquivo já foi totalmente lido ele retorna -1
procurarLivro:
	#O ISBN deve estar em bufferISBN
	move $t8, $ra #  armazena o retorno em $t8
	jal lerArquivoLinhaLivro # lê a proxima linha do arquivo
	beqz $s1, finalArquivo #se o arquivo já foi totalmente lido ele finaliza o procurar livro
	li $a0,2 # campo conde está o ISBN
	jal pegarISBNLivro # retorna o ISBN daquele registro
	move $a0, $v0 # indice do inicio do ISBN
	move $a1, $v1 # indice do final do ISBN
	jal compararISBN #compara os ISBNs
	move $ra, $t8
	jr $ra
	finalArquivo:
		li $v0, -1
		move $ra, $t8
		jr $ra
		
# Essa função pega o ISBN do registro do livro passado em BufferLivro	
pegarISBNLivro: 
	move $t0,$a0 # a0 deve conter o bloco do atributo na linha
	move $t9, $ra # deixa armazenado a funcao que chamou
	li $t1, 0 # variavel para iterar sobre a linha
	li $t2, 0 # variavel para contar o numero de linhas lidas
	li $t3, 0x2C #character que representa uma virgula
	j loopAtributoLivro
	
	somarLinha:
		addi $t2,$t2,1	#soma 1 ao registrador $t2 que contém a quantidade de linhas
		addi $t1, $t1, 1 # pula para o próximo character de bufferLivro
		j loopAtributoLivro
		
	loopAtributoLivro:
		beq $t2,$t0,finalizarLoopAtributoLivro # se $t2 e $t0 forem iguais significa que já temos o endereço do primeiro digito do ISBN
		lb $t5, bufferLivro($t1) # atribui o character para %t5
		beq $t3,$t5,somarLinha # se encontrar uma vigula soma 1 ao registrador $t3
		addi $t1,$t1,1 #incrementa 1 ao registrador de iteração
		j loopAtributoLivro
		
	finalizarLoopAtributoLivro:
		addi $t4,$t1,12#atribui o indice do ultimo indice antes da proxima virgula (tendo em vista que o ISBN tem 13 digitos)
		move $v0,$t1 # passando as variáveis de retorno
		move $v1,$t4
		move $ra $t9 #pegando a funcao que chamou inicialmente 
		jr $ra # voltando para procurarLivro
		
		
#Compara o ISBN inserido pelo usuário com o ISBN contido em bufferLivro
compararISBN:
	move $t9,$ra # armazena a variável de retorno
	li $t0,0x2C # representa a virgula
	move $t1, $a0 # passando os parâmetros de entrada para os registradores do tipo t ($t1 é o endereço do primeiro digito do ISBN e %t2 é o ultimo digito do isbn)
	move $t2, $a1
	li $t3, 0 #variavel para iterar sobre o bufferISBN
		
	loopContarCharacteresAtributo:
		lb $t5, bufferISBN($t3) #atribui o character do Buffer ISBN para %t5
		lb $t6, bufferLivro($t1) # atribui o character do bufferLivro para $t6
		bgt $t1,$t2,finalizarLivroIgual # se $t1 foi maior que $t2 significa que todo o bufferLivro já foi analisado (então os livros são iguais)
		bne $t5,$t6,finalizarLivroDiferente # se $t5 e $t6 forem diferentes significa que os ISBNS são diferentes
		addi $t1,$t1,1 # adiciona +1 mais para a próxima iteração
		addi $t3,$t3,1
		j loopContarCharacteresAtributo
	finalizarLivroDiferente:
		li $v0,0 # se for diferente ele retorna 0
		move $ra, $t9
		jr $ra
	finalizarLivroIgual:
		li $v0,1 # se for igual ele retorna 1
		move $ra,$t9
		jr $ra
	
			 
		 
			 
