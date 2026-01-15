import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/shared/data/async/either.dart';

class GetCepsDetailsByLocalDetails {
  final CepRepository _cepRepository;

  GetCepsDetailsByLocalDetails(this._cepRepository);

  Future<Either<CepException, List<CepResponse>>> call(GetCepsDetailsByLocalDetailsBody body) async {
    return _cepRepository.getCepsDetailsByLocalDetails(body);
  }
  
}