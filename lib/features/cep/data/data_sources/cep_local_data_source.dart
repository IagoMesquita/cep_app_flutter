import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/shared/data/async/either.dart';

abstract interface class CepLocalDataSource {
  Future<Either<CepLocalException, AddressModel?>> getAddressFromCache();

  Future<Either<CepLocalException, void>> saveAddressToCache(
    AddressModel address,
  );
}
