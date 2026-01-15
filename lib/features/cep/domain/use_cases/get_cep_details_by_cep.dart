import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/shared/data/async/either.dart';

class GetCepDetailsByCep {

  final CepRepository _repository;

  GetCepDetailsByCep(this._repository);

  Future<Either<CepException, CepResponse>> call(GetCepDetailsByCepBody body) async {
    return _repository.getCepDetailsByCep(body);
  }
}
