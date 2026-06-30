import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';

/// Interface unificada para operações locais relacionadas a CEP
/// Abstrai o mecanismo de persistência local (SharedPreferences, Hive, etc)
abstract interface class CepLocalDataSource {
  // ========== Operações para Endereco Individual ==========

  /// Recupera o último Endereco consultado do cache local.
  ///
  /// Retorna o [AddressModel] correspondente ou `null` se o cache estiver vazio.
  ///
  /// Throws a [CepLocalException] se houver falha de hardware ou corrupção na leitura do cache.
  Future<AddressModel?> getAddressFromCache();

  /// Armazena um CEP no cache local
  ///
  /// [address] - Modelo de endereço a ser armazenado
  /// Throws a [CepLocalException] se houver falha de escrita no armazenamento local.
  Future<void> saveAddressToCache(AddressModel address);

  // ========== Operações para Lista de Endereços ==========

  /// Recupera lista de endereços do cache local.
  ///
  /// Retorna uma lista de [AddressModel] ou `null` se o cache estiver vazio.
  ///
  /// Throws a [CepLocalException] se houver falha de leitura no armazenamento local.
  Future<List<AddressModel>?> getAddressesListFromCache();

  /// Armazena lista de endereços no cache local.
  ///
  /// [addressList] - Lista de modelos de endereço a serem armazenados.
  ///
  /// Throws a [CepLocalException] se houver falha de escrita no armazenamento local.
  Future<void> saveAddressesListToCache(List<AddressModel> addressList);
}
