📚 Biblioteca_Mips
📌 Trabalho de Arquitetura de Software

📝 Sobre o Projeto
O objetivo deste projeto é implementar um sistema de cadastro de pessoas e automóveis para um condomínio. O sistema funcionará através de um terminal (shell) que interpretará comandos de texto, permitindo que os usuários interajam diretamente com o sistema para executar operações como cadastro, consulta e remoção de registros.

💡 Dica:
É permitido utilizar o terminal padrão do MARS através das chamadas de syscall. Entretanto, grupos que implementarem o sistema utilizando KEYBOARD MMIO e DISPLAY MMIO ganham até 1.0 ponto extra na nota do projeto!

📌 Requisitos do Projeto
O sistema deve oferecer as seguintes funcionalidades:

✅ Cadastro de livros no acervo (título, autor e ISBN).
✅ Cadastro de usuários (nome, matrícula e curso).
✅ Registro de empréstimos de livros.
✅ Registro de devolução de livros.
✅ Cálculo automático de atrasos nos empréstimos.
✅ Consulta da disponibilidade de livros no acervo.
✅ Geração de relatórios detalhados.
✅ Remoção de livros e usuários do sistema.
✅ Salvamento e recuperação de dados em arquivos.
✅ Ajuste manual da data e hora do sistema.
✅ Relógio interno atualizado pelo serviço 30 do syscall do MARS.
✅ Exibição de um banner customizado no terminal.

📜 Lista de Comandos Implementados
❌ Erro de Comando Inválido
Caso um comando não seja reconhecido, a seguinte mensagem será exibida:

Copiar
Editar
Comando inválido! Tente novamente.
📅 1. data_hora
Exibe a data e hora atual do sistema.

🔹 Exemplo de Uso:

Copiar
Editar
data_hora
🔹 Saída:

makefile
Copiar
Editar
Data: 10/12/2024
Hora: 14:35:22
📖 2. cadastrar_livro
Adiciona um novo livro ao acervo.

🔹 Opções Obrigatórias:

--titulo → Define o título do livro.
--autor → Define o autor do livro.
--isbn → Define o código ISBN.
--qtd → Define a quantidade disponível.
🔹 Exemplo de Uso:

arduino
Copiar
Editar
cadastrar_livro --titulo "Dom Casmurro" --autor "Machado de Assis" --isbn "123456789" --qtd "5"
📚 3. listar_livros
Exibe todos os livros cadastrados no acervo.

🔹 Exemplo de Uso:

Copiar
Editar
listar_livros
🔹 Saída (exemplo):

yaml
Copiar
Editar
ISBN: 123456789 | Título: Dom Casmurro | Autor: Machado de Assis | Quantidade: 5 | Emprestados: 2
👤 4. cadastrar_usuario
Registra um novo usuário.

🔹 Opções Obrigatórias:

--nome → Nome do usuário.
--matricula → Número de matrícula.
--curso → Curso do usuário.
🔹 Exemplo de Uso:

arduino
Copiar
Editar
cadastrar_usuario --nome "João Silva" --matricula "2024001" --curso "Engenharia"
📕 5. registrar_emprestimo
Registra o empréstimo de um livro para um usuário.

🔹 Opções Obrigatórias:

--matricula → Matrícula do usuário.
--isbn → ISBN do livro.
--devolucao → Data de devolução prevista (DD/MM/AAAA).
🔹 Exemplo de Uso:

arduino
Copiar
Editar
registrar_emprestimo --matricula "2024001" --isbn "123456789" --devolucao "20/12/2024"
📊 6. gerar_relatorio
Gera um relatório com informações de livros emprestados e usuários em atraso.

🔹 Exemplo de Uso:

Copiar
Editar
gerar_relatorio
🔹 Saída (exemplo):

yaml
Copiar
Editar
📚 Livros Emprestados:
ISBN: 123456789 | Título: Dom Casmurro | Devolução Prevista: 20/12/2024

🚨 Usuários em Atraso:
Matrícula: 2024001 | Nome: João Silva | Livro: Dom Casmurro (ISBN: 123456789) | Atraso: 2 dias
🗑 7. remover_livro
Remove um livro do acervo.

🔹 Exemplo de Uso:

arduino
Copiar
Editar
remover_livro --isbn "123456789"
🚨 Erro se o livro estiver emprestado!

🚫 8. remover_usuario
Remove um usuário do sistema.

🔹 Exemplo de Uso:

arduino
Copiar
Editar
remover_usuario --matricula "2024001"
🚨 Erro se o usuário tiver livros emprestados!

💾 9. salvar_dados
Salva todos os dados em arquivos.

🔹 Exemplo de Uso:

Copiar
Editar
salvar_dados
🛑 10. formatar_dados
Apaga todos os registros do sistema.

🔹 Exemplo de Uso:

Copiar
Editar
formatar_dados
🕒 11. ajustar_data
Permite ajustar manualmente a data e hora do sistema.

🔹 Exemplo de Uso:

kotlin
Copiar
Editar
ajustar_data --data "01/01/2025" --hora "12:00:00"
🔄 12. registrar_devolucao
Registra a devolução de um livro.

🔹 Exemplo de Uso:

arduino
Copiar
Editar
registrar_devolucao --matricula "2024001" --isbn "123456789"
