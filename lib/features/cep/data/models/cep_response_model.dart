import 'dart:convert';

import 'package:cep_app/features/cep/domain/entities/cep_response.dart';

class CepResponseModel extends CepResponse {
  const CepResponseModel({
    required super.cep,
    required super.logradouro,
    required super.complemento,
    required super.bairro,
    required super.localidade,
    required super.uf,
  });

  //  Converte Map → Model
  // Quando você recebe JSON da API e Dio o decodifica para Map<String, dynamic>
  factory CepResponseModel.fromMap(Map<String, dynamic> map) {
    return CepResponseModel(
      cep: map['cep'],
      logradouro: map['logradouro'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
    );
  }

  // Converte String JSON → Model
  // Quando você tem JSON como string (ex: lendo de cache local)
  factory CepResponseModel.fromJson(String json) {
    return CepResponseModel.fromMap(jsonDecode(json));
  }

  // Converte Model → Map
  // Quando você quer serializar para cache local ou enviar para outra API
  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf
    };
  }

  // Converte Model → String JSON
  // Quando você precisa salvar em cache (SharedPreferences, arquivo, etc.)
  // Resultado é uma string JSON compacta
  String toJSON() => jsonEncode(toMap());
}


// factory: e como um construtor que permiti adicionar l'ogica, caso preciso
// factory é um construtor especial que permite lógica e retornar instâncias diferentes
// Diferente de construtor normal, pode ter validação, transformação, etc.
// Não precisa chamar super() diretamente
// Permite lógica no construtor
// Pode fazer transformações, validações
// Pode retornar diferentes tipos (no futuro, por ex)