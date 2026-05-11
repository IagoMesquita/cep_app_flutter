import 'dart:convert';

import 'package:cep_app/features/cep/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.cep,
    required super.logradouro,
    required super.complemento,
    required super.bairro,
    required super.localidade,
    required super.uf,
  });

  //  Converte Map → Model
  // Quando você recebe JSON da API e Dio o decodifica para Map<String, dynamic>
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    // Extrai o CEP e remove caracteres especiais (hifens)
    final rawCep = map['cep'] as String?;
    final cleanCep = rawCep?.replaceAll('-', '') ?? '';
    
    return AddressModel(
      cep: cleanCep,
      logradouro: map['logradouro'] as String? ?? '',
      complemento: map['complemento'] as String? ?? '',
      bairro: map['bairro'] as String? ?? '',
      localidade: map['localidade'] as String? ?? '',
      uf: map['uf'] as String? ?? '',
    );
  }

  // Converte String JSON → Model
  // Quando você tem JSON como string (ex: lendo de cache local)
  factory AddressModel.fromJson(String json) {
    return AddressModel.fromMap(jsonDecode(json));
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