import 'dart:convert';

import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';

abstract interface class GetCepDetailsByLocalDetailsLocalDataSource {
  Future<Either<CepLocalException, List<AddressModel>?>> get();
  Future<Either<CepLocalException, void>> set(
    List<AddressModel> addressEntity,
  );
}

const GET_CEP_BY_LOCAL_DETAILS_LOCAL_KEY = "GET_CEP_BY_LOCAL_DETAILS_LOCAL_KEY";

class GetCepDetailsByLocalDetailsLocalDataSourceImpl
    implements GetCepDetailsByLocalDetailsLocalDataSource {
  final LocalService _sharedPreferences;

  GetCepDetailsByLocalDetailsLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<Either<CepLocalException, List<AddressModel>?>> get() async {
    final localCepEither = await _sharedPreferences.get<String>(
      GET_CEP_BY_LOCAL_DETAILS_LOCAL_KEY,
    );

    return switch (localCepEither) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right(value: final r) => Right(
        r != null
            ? (jsonDecode(r) as List)
                  .map((addressEntity) => AddressModel.fromMap(addressEntity as Map<String, dynamic>))
                  .toList()
            : null,
      ),
    };
  }

  @override
  Future<Either<CepLocalException, void>> set(
    List<AddressModel> addressEntity,
  ) async {
    final addressEntityListLocalResult = await _sharedPreferences.set<String>(
      GET_CEP_BY_LOCAL_DETAILS_LOCAL_KEY,
      jsonEncode(
        addressEntity.map((addressEntity) => addressEntity.toMap()).toList(),
      ),
    );

    return switch (addressEntityListLocalResult) {
      Left(value: final l) => Left(CepLocalException(message: l.message)),
      Right() => Right(null),
    };
  }
}
