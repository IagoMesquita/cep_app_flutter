import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/core/async/either.dart';

class SearchAddressByCep {
  final CepRepository _repository;

  SearchAddressByCep(this._repository);

  Future<Either<AddressFailure, AddressEntity>> call(
    SearchByCepParams param,
  ) async {
    // 1. Sanitização: Remove qualquer caractere que não seja número (ex: hifens, espaços)
    final cleanedCep = param.cep.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. Validação rigorosa dos 8 dígitos numéricos
    final cepPattern = RegExp(r'^\d{8}$');
    if (!cepPattern.hasMatch(cleanedCep)) {
      return Left(InvalidCepFailure());
    }
    // 3. Repassa o parâmetro limpo para o repositório trabalhar com segurança
    return _repository.getAddressByCep(SearchByCepParams(cep: cleanedCep));
  }
}
