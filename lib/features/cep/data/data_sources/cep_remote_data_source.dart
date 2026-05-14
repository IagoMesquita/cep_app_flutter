import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/data/async/either.dart';

/// Interface unificada para operações remotas relacionadas a CEP
/// Abstrai a origem dos dados remotos (API ViaCEP, etc)
abstract interface class CepRemoteDataSource {
  /// Busca detalhes de endereço por CEP
  /// 
  /// [cepParam] - Parâmetros contendo o CEP a ser consultado
  /// Retorna [Either] com [CepRemoteException] ou [AddressModel]
  Future<Either<CepRemoteException, AddressModel>> getAddressDetailsByCep(
    SearchByCepParams cepParam,
  );

  /// Busca lista de CEPs por detalhes do endereço (Estado, Cidade, Rua)
  /// 
  /// [addressParams] - Parâmetros contendo estado, cidade e rua
  /// Retorna [Either] com [CepRemoteException] ou lista de [AddressEntity]
  Future<Either<CepRemoteException, List<AddressModel>>> getAddressDetailsByAddress(
    SearchByAddressParams addressParams,
  );
}
