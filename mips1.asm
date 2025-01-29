.data

# NOMES DOS ARQUIVOS --------------------------------------------------------------------------------------- 
usersFile:  .asciiz "C:/Users/Vin�cius Lima/Documents/UFRPE/biblioteca_Mips/atividade_em_grupo_mars/users.txt"  #Passando o Endere�o complet  #Passando o Endere�o completo- alterei 
conteudoDoarquivoUser: .space 1024  # tamanho do arquivo, n�o pode ser maior 
booksFile:  .asciiz "books.txt"

# MENSAGENS PADROES ----------------------------------------------------------------------------------------
msgMain: .asciiz "Bem vindo/a a livraria da Rural\n\nInforme sua matricula:\n\n"
msgMenu: .asciiz "1- Livros\n2- Usuarios"
msgMatriculaNaoEncontrada: .asciiz "Numero de matricula n?o encontrada, escreva novamente\n"
msgNameUser: .asciiz "Qual o nome do Estudante\n"
msgRegistrationCode: .asciiz "\nQual o numero de matricula\n"
msgCourseUser: .asciiz "\nQual o curso do Estudante\n"

# BUFFERS --------------------------------------------------------------------------------------------------
bufferUser:  .space 100    #verificar se esse numero n?o esta sendo mais que o suficiente (exagero)
bufferLinha: .space 40     #verificar se esse numero ? o suficiente
bufferByte: .space 1
                       
backspace:  .byte 0x08    
space:      .byte 0x20     # espa?o em branco 

.text
.globl main

# REGISTRADORES FIXOS ----------------------------------------------------------------------------------------
# Sempre que for usar os registradores fixos ? necessario varificar se vai alterar algum outro valor, ou caso va usar alguma fun??o que tenha esses registradores (necessario manter uma copia temporaria)
# Caso necessario antes do input tem que salvar o valor de $a0 

# $s0 : indice do bufferUser, indice do bufferUser(inputUser), 
# $s1 : indice do bufferLinha
# $a0 : buffer(clearBuffer), buffer(commaInBuffer), arquivo(saveData), mensagem(showMsg), contador(cleardDisplay), caracterEscrito(inputUser)
# $a1 : indice(clearBuffer), indice(commaInBuffer), buffer(saveData) 
# $a2 : tamanhoString(saveData) 
main:

	li $s0, 0   		# indice do bufferUser
	li $s1, 0		# indice do bufferLinha
	
	#Mensagem de bem vindo e numero de matricua
	la $a0, msgMain
	jal showMsg
	
	jal creatUser
	jal cleardDisplay
	
	j endRun

creatUser:
	addi $sp, $sp, -4   
	sw $ra, 0($sp)     	     # salvar referencia
	 
	move $a1, $s0 		     # parametros da fun??o -> indice(commaInBuffer)
	
	la $a0, msgNameUser          # parametros da fun??o -> mensagem(showMsg)
	jal showMsg
	jal inputUser
	la $a0, bufferUser  	     # parametros da fun??o -> buffer(commaInBuffer)
	jal commaInBuffer
	
	la $a0, msgRegistrationCode  # parametros da fun??o -> mensagem(showMsg)
	jal showMsg
	jal inputUser
	la $a0, bufferUser  	     # parametros da fun??o -> buffer(commaInBuffer)
	jal commaInBuffer
	
	la $a0, msgCourseUser        # parametros da fun??o -> mensagem(showMsg)
	jal showMsg
	jal inputUser
	
	move $s0, $a1		     # Atualiza o indice do buffer
	
	la $a0, bufferUser
	move $a1, $s0
	jal showBuffer
	
	la $a0, usersFile	     # parametros da fun??o -> arquivo(saveData) 
	la $a1, bufferUser	     # parametros da fun??o -> buffer(saveData) 
	move $a2, $s0	 	     # parametros da fun??o -> tamanhoString(saveData) 
	jal saveData
	
	la $a0, bufferUser	      # parametros da fun??o -> buffer(clearBuffer)
	move $a1, $s0		      # parametros da fun??o -> indice(clearBuffer)
	jal clearBuffer               #limpando o buffer
	li $s0, 0		      #Indice 0
	
	lw $ra, 0($sp)       	     # recupera referencia do chamdaor
	addi $sp, $sp, 4    
	
	j return

showBuffer:
# Par?metros
# $a0 -> buffer
# $a1 -> indice
	addi $sp, $sp, -4   
	sw $ra, 0($sp)     	     # salvar referencia
	
	move $t0, $a0
	
	jal loopshowBuffer
	
	move $a0, $t0
	lw $ra, 0($sp)       	     # recupera referencia do chamdaor
	addi $sp, $sp, 4    
	
	j return
	
loopshowBuffer:
	beqz $a1, return    # Se o ?ndice for 0, termina a exibi??o
	move $t1, $a0
	lb $a0, 0($t1)      # caractere do buffer
	li $v0, 11          # imprimir caractere
	syscall
	move $a0, $t1
	addi $a0, $a0, 1    # Avan?a para o pr?ximo caractere
	subi $a1, $a1, 1    # Decrementa o contador
	j loopshowBuffer       # Continua a exibi??o

saveData:
# Par?metros
# $a0 -> Nome do arquivo
# $a1 -> Endere?o da string a ser salva (buffer)
# $a2 -> Tamanho da string a ser salva

	move $t0, $a1
	move $t1, $a2

	li $v0, 13           # abrir arquivo
	move $a0, $a0	     # nome do arquivo
	li $a1, 9            # append
	li $a2, 0            # permissoes 
	syscall
	move $s0, $v0        # descritor do arquivo

	# Escrita no arquivo
	li $v0, 15           # escrita
	move $a0, $s0        # descritor do arquivo
	move $a1, $t0        # endere?o String
	move $a2, $t1        # tamanho String
	syscall
	
	j closeFile

closeFile:	
	li $v0, 16
	move $a0, $a0
	syscall

	j return

commaInBuffer:
# apos o uso tem que atualizar o valor do indice do buffer
# Parametro
# $a0 -> buffer
# $a1 -> indice do buffer
	li $t1, 0x2C        	     # caracter da virgula
	add $t0, $a0, $a1
	sb $t1, 0($t0)      	     # virgula no buffer
	addi $a1, $a1, 1             # +1 indice bufferUser

# FUNCOES SIMPLES MUITO USADAS --------------------------------------------------------------------------------------------------------------------

clearBuffer:
# Apos o uso tem que zerar o valor do indice do buffer
# parametro
# $a0 -> buffer
# $a1 -> indice
	add $a0, $a0, $a1	    #endere?o do ultimo elemento do buffer

	addi $sp, $sp, -4   
	sw $ra, 0($sp)     	     # salvar referencia
	
	jal loopClearBuffer
	
	lw $ra, 0($sp)       	     # recupera referencia
	addi $sp, $sp, 4    
	j return 
	
loopClearBuffer:
	li $t1, 0
	sb $t1, 0($a0) 	     # armazena 0 no buffer
	subi $a0, $a0, 1
	subi $a1, $a1, 1
	bgez $a1, return      	# enquanto ?ndice >= 0

inputUser:
	li $t0, 0xFFFF0000         # endere?o do keyboard status
	lw $t1, 0($t0)             # status do teclado, bit menos significativo = 0 -> sem caracter indisponivel
	andi $t1, $t1, 1           # opera??o AND para verificar o bit menos significativo
	beq $t1, $zero, inputUser     

	# le caractere do teclado
	li $t0, 0xFFFF0004         # endere?o do keyboard data
	lw $a0, 0($t0)             # carrega o caracter
	li $t3, 0x0A 		   # Enter
	beq $a0, $t3, return
	la $t0, bufferUser 
	add $t0, $t0, $s0
	sb $t2, 0($t0)   	    # salva no buffer
	addi $s0, $s0, 1	   # +1 indice bufferUser
	j loopDisplay
	
loopDisplay:
	li $t0, 0xFFFF0008       # endere?o do display status
	lw $t1, 0($t0)           # status do Display, bit menos significativo = 0 -> display indisponivel
	andi $t1, $t1, 1         
	beq $t1, $zero, loopDisplay

	li $t0, 0xFFFF000C       # endere?o do display data
	sw $a0, 0($t0)           # escrita
	j inputUser      

cleardDisplay:
	li $a0, 25       	 # linhas em branco (contador)
	j clearLoop
	
clearLoop:
	li $t1, 0xFFFF0008         # endere?o do display status
	lw $t2, 0($t1)             # status do display
	andi $t2, $t2, 1
	beq $t2, $zero, clearLoop  # se ocupado, espera
	li $t1, 0xFFFF000C         # endere?o do display data
	
	li $t0, 0x0A               # pula linha
	sw $t0, 0($t1)             # escreve
	subi $a0, $a0, 1           # -1 contador
	bgtz $a0, clearLoop        # Repete at? o contador chegar a 0

 	jr $ra    
 	
showMsg:
# Parametro 
# $a0 -> mensagem
	lb $t0, 0($a0)		  #caractere
	beqz $t0, return	  #verifica se terminou
	li $t1, 0xFFFF0008        # endere?o do display status
	j loopDisplaymsg    	  #loop escrita
	
loopDisplaymsg:
	lw $t2, 0($t1)           # status do display
	andi $t2, $t2, 1         
	beq $t2, $zero, loopDisplaymsg  # se ocupado, espera

	li $t1, 0xFFFF000C       # endere?o do display data
	sw $t0, 0($t1)           # escreve

	addi $a0, $a0, 1  	 # pr?ximo caractere
	j showMsg    
endRun:
	li $v0, 10   
	syscall      
return:
	jr $ra
	


lerArquivoUser:
	li $v0, 13 #solicita a  abertura do arquivo USer
	la $a0, usersFile #endere�o do arquivo 
	li $a1, 0 #leitura do arquvo
	syscall #Descritor do arquivo vai para $v0
	
	move $s0, $v0 #copia do descritor
	
	move $a0, $s0
	li $v0, 14 #ler o conteudo referenciado por $a0
	la $a1,conteudoDoarquivoUser #buffer que armazena o conteudo
	li $a2, 1024 #tamanho do buffer
	syscall
	
	li $v0, 4 #imprimir o conteudo do arquivo
	move $a0, $a1
	syscall
	
	li $v0,16 # fechar o arquivo
	move $a0 ,$s0
	syscall
	
	

