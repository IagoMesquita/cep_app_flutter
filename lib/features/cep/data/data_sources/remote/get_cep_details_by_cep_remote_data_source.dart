import 'package:cep_app/features/cep/data/data_sources/const/get_cep_error_messages.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/cep_response_model.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';



abstract interface class GetCepDetailsByCepRemoteDataSource {
  Future<Either<CepRemoteException, CepResponseModel>> call(GetCepDetailsByCepBody cepBody);
}


class GetCepDetailsByCepRemoteDataSourceImpl implements GetCepDetailsByCepRemoteDataSource {
  
  final ApiService _apiService;

  GetCepDetailsByCepRemoteDataSourceImpl(this._apiService); 
  
  @override
  Future<Either<CepRemoteException, CepResponseModel>> call(GetCepDetailsByCepBody cepBody) async {
    final cepEither = await _apiService.get('/${cepBody.cep}/json/');

    switch(cepEither) {
      case Left(value: final l):
        return switch(l.errorStatus) {
          ErrorStatus.noConnection => throw NoInternetException(),
          ErrorStatus.badRequest => Left(CepRemoteException(message: GetCepErrorMessages.invalidZipCode)),
          _ => Left(CepRemoteException(message: l.message))
        };
        case Right(value: final r):
          return Right(CepResponseModel.fromMap(r.data));
    }

  }

}

