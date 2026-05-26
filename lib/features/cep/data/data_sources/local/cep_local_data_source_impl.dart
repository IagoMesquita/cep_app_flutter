import 'dart:convert';

import 'package:cep_app/features/cep/data/data_sources/cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';

const kGetAddressByCepLocalKey = 'GET_CEP_BY_CEP_LOCAL_KEY';
const kGetListAddressByLocalDetailsLocalKey =
    'GET_LISTADDRESS_BY_LOCAL_DETAILS_LOCAL_KEY';

class CepLocalDataSourceImpl implements CepLocalDataSource {
  final LocalService _localService;

  CepLocalDataSourceImpl(this._localService);

  // ========== Operações para Endereco Individual ==========

  @override
  Future<Either<CepLocalException, AddressModel?>> getAddressFromCache() async {
    final localAddress = await _localService.get<String>(
      kGetAddressByCepLocalKey,
    );

    return switch (localAddress) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right(value: final r) => Right(
        r != null ? AddressModel.fromJson(r) : null,
      ),
    };
  }

  @override
  Future<Either<CepLocalException, void>> saveAddressToCache(
    AddressModel address,
  ) async {
    final localAddressEither = await _localService.set<String>(
      kGetAddressByCepLocalKey,
      address.toJSON(),
    );

    return switch (localAddressEither) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right() => Right(null),
    };
  }

  // ========== Operações para Lista de Endereços ==========

  @override
  Future<Either<CepLocalException, List<AddressModel>?>>
  getAddressesListFromCache() async {
    final localListAddressEither = await _localService.get<String>(
      kGetListAddressByLocalDetailsLocalKey,
    );

    return switch (localListAddressEither) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right(value: final r) => Right(
        r != null
            ? (jsonDecode(r) as List)
                  .map(
                    (item) =>
                        AddressModel.fromMap(item as Map<String, dynamic>),
                  )
                  .toList()
            : null,
      ),
    };
  }

  @override
  Future<Either<CepLocalException, void>> saveAddressesListToCache(
    List<AddressModel> addressList,
  ) async {
    final localListAddressEither = await _localService.set<String>(
      kGetListAddressByLocalDetailsLocalKey,
      jsonEncode(addressList.map((item) => item.toMap()).toList()),
    );

    return switch (localListAddressEither) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right() => Right(null),
    };
  }
}
