import 'package:equatable/equatable.dart';

class CepResponse extends Equatable {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;

  const CepResponse(
  {
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  }
  );

  @override
  List<Object?> get props => [
    cep,
    logradouro,
    complemento,
    bairro,
    localidade,
    uf
  ];
}

//// O que é uma Entidade (Entity)?
// A Entidade representa o objeto de negócio "puro". 
//Ela contém a lógica central e os dados essenciais da sua aplicação, sem se preocupar de onde os 
//dados vêm (se é de uma API, de um banco de dados ou de um arquivo).

/// Foco: Regras de negócio.
// Estabilidade: Ela muda raramente (apenas se a regra de negócio mudar).
// Independência: Não deve conhecer bibliotecas externas (como json_serializable ou sqflite).
