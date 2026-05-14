import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_local_details_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_local_details_remote_data_source.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

class CepRepositoryImpl implements CepRepository {
  final GetCepDetailsByCepRemoteDataSource _getCepByRemote;
  final GetCepDetailsByCepLocalDataSource _getCepByLocal;
  final GetCepDetailsByLocalRemoteDataSource
  _getCepDetailsByLocalRemoteDataSource;
  final GetCepDetailsByLocalDetailsLocalDataSource
  _getCepDetailsByLocalDetailsLocalDataSource;

  CepRepositoryImpl(
    this._getCepByRemote,
    this._getCepByLocal,
    this._getCepDetailsByLocalRemoteDataSource,
    this._getCepDetailsByLocalDetailsLocalDataSource,
  );

  @override
  Future<Either<AddressFailure, AddressEntity>> getCepDetailsByCep(
    SearchByCepParams cep,
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
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }

  @override
  Future<Either<AddressFailure, List<AddressEntity>>> getCepsDetailsByLocalDetails(
    SearchByAddressParams addressParams,
  ) async {
    try {
      final cepResponseByLocalDetailsEither =
          await _getCepDetailsByLocalRemoteDataSource(addressParams);

      switch(cepResponseByLocalDetailsEither) {
        case Left(value: final l):
          return Left(l);
        case Right(value: final r):
          await _getCepDetailsByLocalDetailsLocalDataSource.set(r as List<AddressModel>);
          return Right(r);  
      }    
    } on NoInternetException {
      final localListOfAddressEntity = await _getCepDetailsByLocalDetailsLocalDataSource.get();

      return switch(localListOfAddressEntity) {
        Left(value: final l) => Left(CepLocalException(message: l.message)),
        Right(value: final r) => Left(LocalDetailsInternetConnectionException(cepList: r))
      };
      
    } catch (e) {
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }
}
