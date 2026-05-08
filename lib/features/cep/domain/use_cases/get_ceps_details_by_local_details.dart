import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/shared/data/async/either.dart';

class GetCepsDetailsByLocalDetails {
  final CepRepository _cepRepository;

  GetCepsDetailsByLocalDetails(this._cepRepository);

  Future<Either<CepException, List<AddressEntity>>> call(SearchByAddressParams param) async {
    return _cepRepository.getCepsDetailsByLocalDetails(param);
  }
  
}