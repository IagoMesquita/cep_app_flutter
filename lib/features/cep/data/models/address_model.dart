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
      'uf': uf,
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

// Essa é a confusão mais comum para quem está começando com Clean Arch no Flutter, 
// mas a lógica é bem simples quando você separa por "territórios"
//.Vamos colocar os pingos nos is:1. 
//Quem "trabalha" é a Entidade (AddressEntity)
//A Entidade é o coração do seu domínio.
//Onde ela vive? Na camada de Domain.
//O que ela faz? 
//Ela é usada pelos seus UseCases e pela sua UI (Widgets).
//A regra de ouro: A Entidade não sabe o que é um JSON, 
//não sabe o que é uma API e não sabe o que é um banco de dados. 
//Ela é apenas Dart "puro".2. O Model é o "Tradutor" (AddressModel)
//O Model é uma classe da camada de Data.
//Ele estende a Entidade apenas para que você possa passá-lo para o resto do app
// fingindo que ele é uma Entidade.
//A função dele é conversa fiada com o mundo externo.3. 
//Quando usar Map vs. JSON?Sua intuição está no caminho certo, mas no ecossistema Dart/Flutter, 
//o uso é um pouco mais específico:O Map<String, dynamic> (O formato intermediário)No Dart, 
//quase nenhuma biblioteca trabalha com a String JSON diretamente. Elas trabalham com Maps.
//APIs (Dio / Http): Quando você recebe uma resposta da API, o Dio já faz o jsonDecode para você e 
//te entrega um Map.Por isso você usa o fromMap.
//Banco de Dados Local (SQFlite): Se você salvar o endereço num banco SQL local, o driver do banco 
//exige que você passe um Map.Resumo: O Map é o padrão para falar com pacotes/bibliotecas.
//O JSON / String (O formato de transporte/armazenamento)A String (o JSON bruto) é usada quando 
//você não tem uma estrutura de dados complexa ao redor:Cache Simples (SharedPreferences): 
//O SharedPreferences só salva tipos básicos (String, int, bool). Para salvar um objeto lá, 
//você o transforma em String via toJSON().Logs: Para printar o objeto no console de forma legível.
//Devolução para Externos: Se você estivesse criando uma API em Dart (com Shelf ou Dart Frog), 
//você enviaria a String JSON no corpo da resposta.Comparando com seu mundo (NestJS / Spring)
//Para você nunca mais esquecer:
//CamadaFlutter (Clean Arch)NestJS / SpringDomainAddressEntityEntity (TypeORM/JPA) 
//ou Domain ObjectDataAddressModelDTO (Data Transfer Object)MecanismofromMap / toMapclass-transformer / Jackson
//O fluxo seria esse:API manda um JSON (String).Dio recebe e transforma em Map.
//Repository chama AddressModel.fromMap(map).
//O Repository entrega o objeto como AddressEntity para o UseCase.
//O UseCase faz a lógica de negócio e entrega para a UI.