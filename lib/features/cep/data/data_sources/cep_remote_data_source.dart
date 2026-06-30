import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';

/// Interface unificada para operações remotas relacionadas a CEP
/// Abstrai a origem dos dados remotos (API ViaCEP, etc)
abstract interface class CepRemoteDataSource {
  /// Busca detalhes de endereço por CEP.
  ///
  /// [cepParam] - Parâmetros contendo o CEP a ser consultado.
  ///
  /// Retorna um [AddressModel] em caso de sucesso.
  ///
  /// Throws a [CepRemoteException] se a API retornar um erro de negócio ou formato inválido.
  /// Throws a [NoInternetException] se o dispositivo estiver totalmente offline.
  Future<AddressModel> getAddressByCep(SearchByCepParams cepParam);

  /// Busca lista de CEPs por detalhes do endereço (Estado, Cidade, Rua).
  /// 
  /// [addressParams] - Parâmetros contendo estado, cidade e rua.
  /// 
  /// Retorna uma lista contendo [AddressModel] em caso de sucesso.
  /// 
  /// Throws a [CepRemoteException] se a API retornar um erro de negócio ou parâmetros inválidos.
  /// Throws a [NoInternetException] se o dispositivo estiver totalmente offline.
  Future<List<AddressModel>> getAddressesListByAddress(
    SearchByAddressParams addressParams,
  );
}
