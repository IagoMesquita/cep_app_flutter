import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/data/async/either.dart';

abstract interface class CepRepository {
  Future<Either<AddressFailure, AddressEntity>> getCepDetailsByCep(
    SearchByCepParams cep,
  );

  Future<Either<AddressFailure, List<AddressEntity>>> getCepsDetailsByLocalDetails(
    SearchByAddressParams address,
  );
}
