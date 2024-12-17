// Exemplo do Pacote sqlite3 2.1.0
// Isabelle silva castello branco 
// Botei indicando oq cada execuçao faz.

import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  print('Using sqlite3 ${sqlite3.version}');

  // Criação de um banco de dados em memória
  final db = sqlite3.openInMemory();

  // Criação da tabela
  db.execute('''
    CREATE TABLE TB_Estudantes (
      id INTEGER NOT NULL PRIMARY KEY,   
      nome TEXT NOT NULL,                
      idade INTEGER                      
    );
  ''');

  // Inserção assíncrona de registros
  await inserirEstudante(db, 'Isabelle', 16);
  await inserirEstudante(db, 'Isadora', 17);

  // Consulta assíncrona de registros
  print('\n Dados após inserção:');
  await consultarEstudantes(db);

  // Atualização assíncrona de registros
  await atualizarEstudante(db, 1, 'Isabelle Silva', 17);
  print('\n Dados após atualização:');
  await consultarEstudantes(db);

  // Exclusão assíncrona de registros
  await excluirEstudante(db, 2);
  print('\n Dados após exclusão:');
  await consultarEstudantes(db);

  // Encerramento do banco
  db.dispose();
}

// Função assíncrona para inserir registros
Future<void> inserirEstudante(Database db, String nome, int idade) async {
  await Future(() {
    final stmt = db.prepare('INSERT INTO TB_Estudantes (nome, idade) VALUES (?, ?)');
    stmt.execute([nome, idade]);
    stmt.dispose();
    print('Registro inserido: $nome, $idade anos');
  });
}

// Função assíncrona para consultar registros
Future<void> consultarEstudantes(Database db) async {
  await Future(() {
    final resultSet = db.select('SELECT * FROM TB_Estudantes');
    for (final row in resultSet) {
      print('Estudante[id: ${row['id']}, nome: ${row['nome']}, idade: ${row['idade']}]');
    }
  });
}

// Função assíncrona para atualizar registros
Future<void> atualizarEstudante(Database db, int id, String novoNome, int novaIdade) async {
  await Future(() {
    db.execute('UPDATE TB_Estudantes SET nome = ?, idade = ? WHERE id = ?', [novoNome, novaIdade, id]);
    print('Registro atualizado: id=$id -> $novoNome, $novaIdade anos');
  });
}

// Função assíncrona para excluir registros
Future<void> excluirEstudante(Database db, int id) async {
  await Future(() {
    db.execute('DELETE FROM TB_Estudantes WHERE id = ?', [id]);
    print('Registro excluído: id=$id');
  });
}
