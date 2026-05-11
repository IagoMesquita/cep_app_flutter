import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

abstract interface class GetCepDetailsByLocalRemoteDataSource {
  Future<Either<CepRemoteException, List<AddressEntity>>> call(
    SearchByAddressParams addressParams,
  );
}

class GetCepDetailsByLocalDetailsRemoteDataSourceImpl
    implements GetCepDetailsByLocalRemoteDataSource {
  ApiService _apiService;

  GetCepDetailsByLocalDetailsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<CepRemoteException, List<AddressEntity>>> call(
    SearchByAddressParams addressParams,
  ) async {
    final cepDetailsByLocalDetailsEither = await _apiService.get<List>(
      '/${addressParams.estado}/${addressParams.cidade}/${addressParams.rua}/json/',
    );

    switch (cepDetailsByLocalDetailsEither) {
      case Left(value: final l):
        return switch (l.errorStatus) {
          ErrorStatus.noConnection => throw NoInternetException(),
          ErrorStatus.badRequest => Left(
            CepRemoteException(message: l.message!),
          ),
          _ => Left(CepRemoteException(message: l.message)),
        };
      case Right(value: final r):
        return Right(
          (r.data as List)
              .map((cepResponse) => AddressModel.fromMap(cepResponse as Map<String, dynamic>))
              .toList(),
        );
    }
  }
}
