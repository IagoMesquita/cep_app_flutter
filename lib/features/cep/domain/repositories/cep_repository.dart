import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/core/async/either.dart';

abstract interface class CepRepository {
  Future<Either<AddressFailure, AddressEntity>> getAddressByCep(
    SearchByCepParams cep,
  );

  Future<Either<AddressFailure, List<AddressEntity>>> getAddressesListByAdress(
    SearchByAddressParams address,
  );
}
