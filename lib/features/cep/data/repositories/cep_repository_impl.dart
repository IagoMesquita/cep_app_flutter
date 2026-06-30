import 'package:cep_app/features/cep/data/data_sources/cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/core/async/either.dart';
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
      // 1. O DataSource remoto retorna o Model puro ou joga um throw
      final addressModel = await _remoteDataSource.getAddressByCep(cep);

      // 2. Fluxo de sucesso: salva no cache de forma assíncrona e retorna à camada superior
      await _localDataSource.saveAddressToCache(addressModel);
      return Right(addressModel);
    } on NoInternetException {
      try {
        // 3. Sem conexão: tenta recuperar a última consulta válida salva localmente
        final cachedAddress = await _localDataSource.getAddressFromCache();
        if (cachedAddress != null) {
          // Entrega o dado antigo encapsulado na Failure de contingência offline!
          return Left(
            NotInternetWithAdressCacheFailure(lastSavedAddress: cachedAddress),
          );
        }
        return Left(
          AddressFailure(message: ConstStrings.kNoInternetConnectionMessage),
        );
      } on CepLocalException catch (e) {
        return Left(AddressFailure(message: e.message));
      }
    } on CepRemoteException catch (e) {
      return Left(AddressFailure(message: e.message));
    } catch (e) {
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }

  @override
  Future<Either<AddressFailure, List<AddressEntity>>> getAddressesListByAdress(
    SearchByAddressParams addressParams,
  ) async {
    try {
      final addressesList = await _remoteDataSource.getAddressesListByAddress(
        addressParams,
      );

      await _localDataSource.saveAddressesListToCache(addressesList);

      return Right(addressesList);
    } on NoInternetException {
      try {
        final cachedList = await _localDataSource.getAddressesListFromCache();
        if (cachedList != null && cachedList.isNotEmpty) {
          return Left(
            NotInternetWithAddressesListCacheFailure(
              lastSavedAddressesList: cachedList,
            ),
          );
        }

        return Left(
          AddressFailure(message: ConstStrings.kNoInternetConnectionMessage),
        );
      } on CepLocalException catch (e) {
        return Left(AddressFailure(message: e.message));
      }
    } on CepRemoteException catch (e) {
      return Left(AddressFailure(message: e.message));
    } catch (_) {
      return Left(AddressFailure(message: ConstStrings.kDefaultError));
    }
  }
}
