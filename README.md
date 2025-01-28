# biblioteca_Mips
Trabalho de Arquitetura de Software

O objetivo deste projeto é implementar um sistema de cadastro de pessoas e automóveis para um condomínio. Este sistema de cadastro deve ser operado através de um terminal (shell) que funciona como um interpretador de comandos de texto, ou seja, o sistema vai ficar constantemente checando por entradas de texto (string) e interpretando o que for recebido a partir de uma lista de comandos que o sistema deve ser capaz de executar. Os comandos que devem ser implementados serão descritos adiante na seção de requisitos de projeto. 

ATENÇÃO: é permitido utilizar o terminal padrão do MARS através das chamadas de syscall. Entretanto, o grupo que implementar o sistema utilizando o KEYBOARD MMIO e DISPLAY MMIO ganha (até) 1.0 ponto extra na nota  do projeto!!

Sugestão: evite trabalhar com acentos e cedilhas por simplicidade. 
Requisitos de Projeto
O sistema deve ser capaz de cadastrar livros no acervo, permitindo o registro de título, autor e ISBN.
O sistema deve ser capaz de cadastrar usuários, armazenando nome, matrícula e curso.
O sistema deve ser capaz de registrar empréstimos de livros, vinculando-os a usuários previamente cadastrados e armazenando as datas de retirada e devolução previstas.
O sistema deve ser capaz de registrar a devolução de livros, atualizando o status de disponibilidade no acervo e confirmando a data de devolução efetiva.
O sistema deve ser capaz de calcular automaticamente atrasos com base na data atual do sistema e na data de devolução prevista.
O sistema deve ser capaz de consultar a disponibilidade de livros no acervo, informando se estão disponíveis para empréstimo ou não.
O sistema deve ser capaz de gerar relatórios que listem os livros atualmente emprestados, os usuários em atraso e o tempo de atraso (em dias).
O sistema deve ser capaz de remover registros de livros do acervo.
O sistema deve ser capaz de remover registros de usuários.
O sistema deve ser capaz de salvar todos os dados registrados em arquivos, de modo que as informações sejam recuperadas na inicialização.
O sistema deve permitir o ajuste manual da data e hora do sistema.
O sistema deve ser capaz de remover registros de livros do acervo.
O sistema deve ser capaz de remover registros de usuários.
O sistema deve ser capaz de salvar todos os dados registrados em arquivos, de modo que as informações sejam recuperadas na inicialização.
O sistema deve permitir o ajuste manual da data e hora do sistema.
O sistema deve ter um relógio interno que atualiza constantemente a data e hora atual, utilizando o serviço 30 do syscall do MARS.
O sistema deve exibir uma string padrão (banner) no início de cada linha do terminal, utilizando o formato: xxxxxx-shell>>, em que xxxxxx é o nome do sistema a escolha dos alunos.
Comandos Detalhados
Erro de Comando Inválido - Caso geral
Caso o usuário digite um comando que não está listado no sistema, será apresentada a seguinte mensagem:
Mensagem de Erro:Comando inválido! Tente novamente.
Comando 1. data_hora
Exibe a data e hora atual do sistema, conforme mantida pelo relógio interno.
Opções:
Nenhuma.
Exemplo de Uso:
data_hora
Formato de Saída:
Data: 10/12/2024
Hora: 14:35:22
Comando 2. cadastrar_livro
Adiciona um novo livro ao acervo da biblioteca.
Opções Obrigatórias:
--titulo: Define o título do livro.
--autor: Define o autor do livro.
--isbn: Define o código ISBN do livro.
--qtd: Define a quantidade de exemplares disponíveis deste livro.
Cenários de Erro:
Falta de argumento obrigatório:
Mensagem de Erro: O campo "--xxxxxxx" é obrigatório.
Exemplo de Uso:
cadastrar_livro --titulo "Dom Casmurro" --autor "Machado de Assis" --isbn "123456789" --qtd “5” 
Comando 3. listar_livros
Exibe uma lista de todos os livros cadastrados no acervo, incluindo título, autor e ISBN, quantidade total e quantidade atualmente emprestada
Opções:
Nenhuma.
Cenários de Erro:
Acervo vazio:
Mensagem de Erro: O acervo está vazio.
Exemplo de Uso:
Listar_livros
Comando 4. cadastrar_usuario
Registra um novo usuário na biblioteca.

Opções Obrigatórias:
--nome: Nome do usuário.
--matricula: Número de matrícula.
--curso: Curso do usuário.
Cenários de Erro:
Falta de argumento obrigatório:
Mensagem de Erro: O campo "--xxxxxxxx" é obrigatório.
Exemplo de Uso:
cadastrar_usuario --nome "João Silva" --matricula "2024001" --curso "Engenharia"
Comando 5. registrar_emprestimo
Registra o empréstimo de um livro para um usuário, armazenando a data de retirada e a data de devolução prevista.
Opções Obrigatórias:
--matricula: Matrícula do usuário.
--isbn: ISBN do livro.
--devolucao: Data de devolução prevista no formato DD/MM/AAAA.
Opções não obrigatórias:
--data: Data do empréstimo no formato DD/MM/AAAA. (caso não seja fornecida, usar a data atual do sistema)
Cenários de Erro:
Falta de argumento obrigatório:
Mensagem de Erro: O campo "--xxxxxxxxxxxxxx" é obrigatório.
Livro indisponível para empréstimo:
Mensagem de Erro: O livro informado está indisponível para empréstimo.
Exemplo de Uso:
registrar_emprestimo --matricula "2024001" --isbn "123456789" --data "10/12/2024" --devolucao "20/12/2024"
Comando 6. gerar_relatorio
Gera um relatório contendo:
Livros atualmente emprestados, com título, ISBN e quantidades, e data de devolução prevista.
Usuários em atraso, com matrícula, nome, ISBN dos livros atrasados e o número de dias de atraso.
Opções:
Nenhuma.
Cenários de Erro:
Falta de dados:
Mensagem de Erro: Não há dados disponíveis para gerar o relatório.
Exemplo de Uso:
gerar_relatorio
Formato de Saída:
Livros Emprestados:
ISBN: 123456789 | Título: Dom Casmurro | Devolução Prevista: 20/12/2024
Usuários em Atraso:
Matrícula: 2024001 | Nome: João Silva
Livro: Dom Casmurro (ISBN: 123456789) | Atraso: 2 dias

Comnado 7. remover_livro
Remove um livro do acervo da biblioteca.
Opções Obrigatórias:
--isbn: Define o código ISBN do livro a ser removido.
Cenários de Erro:
Livro não encontrado. Mensagem de Erro: O livro informado não foi encontrado no acervo.
Livro está emprestado. Mensagem de erro: O livro não pode ser removido por estar emprestado.
Exemplo de Uso:
remover_livro --isbn "123456789"
Comando 8. remover_usuario
Remove o registro de um usuário da biblioteca.
Opções Obrigatórias:
--matricula: Define a matrícula do usuário a ser removido.
Cenários de Erro:
Usuário não encontrado:
Mensagem de Erro: O usuário informado não foi encontrado.
Usuário tem livro emprestado. 
Mensagem de Erro: O usuário tem pendências de devolução. 
Exemplo de Uso:
remover_usuario --matricula "2024001"

Comando 9. salvar_dados
Salva todos os dados registrados em arquivo.
Opções:
Nenhuma.
Exemplo de Uso:
salvar_dados
Formato de Saída:
Os dados são salvos automaticamente em arquivos específicos no diretório do sistema.
Comando 10. formatar_dados
Apaga todos os registros do sistema
Opções:
Nenhuma.
Exemplo de Uso:
formatar_dados
Formato de Saída:
Os dados são formatados na memória principal, mas a formatação não deve ser salva automaticamente no arquivo. Para isso, deve formatar_dados e depois salvar_dados. 

Comando 10. ajustar_data
Permite ajustar manualmente a data e hora do sistema.
Opções Obrigatórias:
--data: Nova data no formato DD/MM/AAAA.
--hora: Nova hora no formato HH:MM:SS.
Cenários de Erro:
Formato de data ou hora inválido:
Mensagem de Erro: O formato da data ou hora está incorreto.
Exemplo de Uso:
ajustar_data --data "01/01/2025" --hora "12:00:00"

Comando 11. Registrar_devolucao
Registra a devolução de um livro por um usuário, removendo a pendência do usuário para com este livro e colocando o exemplar novamente disponível.
Opções Obrigatórias:
--matricula: Matrícula do usuário.
--isbn: ISBN do livro.
Cenários de Erro:
Falta de argumento obrigatório:
Mensagem de Erro: O campo "--xxxxxxxxxxxxxx" é obrigatório.
Usuário não se encontra com esse livro emprestado:
Mensagem de Erro: O livro informado não foi emprestado para o usuário.
Exemplo de Uso:
registrar_devolução --matricula "2024001" --isbn "123456789" 
