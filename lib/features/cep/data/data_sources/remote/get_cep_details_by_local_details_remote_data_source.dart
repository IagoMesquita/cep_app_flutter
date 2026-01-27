import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/cep_response_model.dart';
import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

abstract interface class GetCepDetailsByLocalRemoteDataSource {
  Future<Either<CepRemoteException, List<CepResponse>>> call(
    GetCepsDetailsByLocalDetailsBody localDetails,
  );
}

class GetCepDetailsByLocalDetailsRemoteDataSourceImpl
    implements GetCepDetailsByLocalRemoteDataSource {
  ApiService _apiService;

  GetCepDetailsByLocalDetailsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<CepRemoteException, List<CepResponse>>> call(
    GetCepsDetailsByLocalDetailsBody localDetails,
  ) async {
    final cepDetailsByLocalDetailsEither = await _apiService.get<List>(
      '${localDetails.estado}/${localDetails.cidade}/${localDetails.rua}/josn/',
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
          r.data
              .map((cepResponse) => CepResponseModel.fromMap(cepResponse))
              .toList(),
        );
    }
  }
}
