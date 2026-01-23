import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_cep_remote_data_source.dart';
import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

class CepRepositoryImpl implements CepRepository {
  final GetCepDetailsByCepRemoteDataSource _getCepByRemote;
  final GetCepDetailsByCepLocalDataSource _getCepByLocal;

  CepRepositoryImpl(this._getCepByRemote, this._getCepByLocal);

  @override
  Future<Either<CepException, CepResponse>> getCepDetailsByCep(
    GetCepDetailsByCepBody cep,
  ) async {
    try {
      final cepEitherResponse = await _getCepByRemote(cep);

      switch (cepEitherResponse) {
        case Left(value: final l):
          return Left(l);
        case Right(value: final r):
          await _getCepByLocal.set(r);
          return Right(r);
      }
    } on NoInternetException {
      final localCep = await _getCepByLocal.get();

      return switch (localCep) {
        Left(value: final l) => Left(CepLocalException(message: l.message)),
        Right(value: final r) => Left(CepInterConnectionException(cep: r)),
      };
    } catch (e) {
      return Left(CepException(message: ConstStrings.kDefaultError));
    }
  }
  
  @override
  Future<Either<CepException, List<CepResponse>>> getCepsDetailsByLocalDetails(GetCepsDetailsByLocalDetailsBody cep) {
    // TODO: implement getCepsDetailsByLocalDetails
    throw UnimplementedError();
  }

}
