import 'package:cep_app/features/cep/data/data_sources/cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

// Reafatoracao:
/// Implementação do repositório de CEP seguindo Clean Architecture
///
/// Depende apenas de abstrações (interfaces) para acesso remoto e local,
/// facilitando testes e manutenção através da Inversão de Dependências
class CepRepositoryImpl implements CepRepository {
  final CepRemoteDataSource _remoteDataSource;
  final CepLocalDataSource _localDataSource;

  /// Construtor com injeção de dependências
  ///
  /// [_remoteDataSource] - Fonte de dados remota (API)
  /// [_localDataSource] - Fonte de dados local (Cache)
  CepRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<AddressFailure, AddressEntity>> getAddressByCep(
    SearchByCepParams cep,
  ) async {
    try {
      // Tenta buscar dados remotos
      final cepEitherResponse = await _remoteDataSource.getAddressByCep(
        cep,
      );

      switch (cepEitherResponse) {
        case Left(value: final l):
          return Left(l);
        case Right(value: final r):
          // Sucesso: salva no cache e retorna
          await _localDataSource.saveAddressToCache(r);
          return Right(r);
      }
    } on NoInternetException {
      // Sem internet: busca no cache local
      final localCep = await _localDataSource.getAddressFromCache();

      return switch (localCep) {
        Left(value: final l) => Left(CepLocalException(message: l.message)),
        Right(value: final r) => Left(CepInterConnectionException(cep: r)),
      };
    } catch (e) {
      // Erro inesperado
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }

  @override
  Future<Either<AddressFailure, List<AddressEntity>>>
  getAddressesListByAdress(SearchByAddressParams addressParams) async {
    try {
      final cepResponseByLocalDetailsEither = await _remoteDataSource
          .getAddressesListByAddress(addressParams);

      switch (cepResponseByLocalDetailsEither) {
        case Left(value: final l):
          return Left(l);
        case Right(value: final r):
          // Sucesso: salva no cache e retorna
          await _localDataSource.saveAddressesListToCache(r);
          return Right(r);
      }
    } on NoInternetException {
          // Sem internet: busca no cache local
      final localListOfAddressEntity =
          await _localDataSource.getAddressesListFromCache();

      return switch (localListOfAddressEntity) {
        Left(value: final l) => Left(CepLocalException(message: l.message)),
        Right(value: final r) => Left(
          LocalDetailsInternetConnectionException(cepList: r),
        ),
      };
    } catch (e) {
      // Erro inesperado
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }
}
