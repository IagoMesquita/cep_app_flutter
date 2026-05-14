import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/shared/data/async/either.dart';

/// Interface unificada para operações locais relacionadas a CEP
/// Abstrai o mecanismo de persistência local (SharedPreferences, Hive, etc)
abstract interface class CepLocalDataSource {
  // ========== Operações para Endereco Individual ==========

  /// Recupera o último Endereco consultado do cache local
  ///
  /// Retorna [Either] com [CepLocalException] ou [AddressModel] (pode ser null)
  Future<Either<CepLocalException, AddressModel?>> getAddressFromCache();

  /// Armazena um CEP no cache local
  /// 
  /// [address] - Modelo de endereço a ser armazenado
  /// Retorna [Either] com [CepLocalException] ou [void]
  Future<Either<CepLocalException, void>> saveAddressToCache(
    AddressModel address,
  );

    // ========== Operações para Lista de Endereços ==========
  
  /// Recupera lista de endereços do cache local
  /// 
  /// Retorna [Either] com [CepLocalException] ou lista de [AddressModel] (pode ser null)
  Future<Either<CepLocalException, List<AddressModel>?>> getAddressListFromCache();

  /// Armazena lista de endereços no cache local
  /// 
  /// [addressList] - Lista de modelos de endereço a serem armazenados
  /// Retorna [Either] com [CepLocalException] ou [void]
  Future<Either<CepLocalException, void>> saveAddressListToCache(
    List<AddressModel> addressList,
  );
}
