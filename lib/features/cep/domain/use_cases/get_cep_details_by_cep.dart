import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/data/async/either.dart';

class GetCepDetailsByCep {

  final CepRepository _repository;

  GetCepDetailsByCep(this._repository);

  Future<Either<AddressFailure, AddressEntity>> call(SearchByCepParams param) async {
    // Validação: CEP deve ter exatamente 8 caracteres numéricos
    final cepPattern = RegExp(r'^\d{8}$');
    if (!cepPattern.hasMatch(param.cep)) {
      return Left(InvalidCepFailure());
    }

    return _repository.getCepDetailsByCep(param);
  }
}
