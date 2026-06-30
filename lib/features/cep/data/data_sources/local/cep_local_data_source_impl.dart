import 'dart:convert';

import 'package:cep_app/features/cep/data/data_sources/cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/shared/data/local/errors/local_exception.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';

const kGetAddressByCepLocalKey = 'GET_CEP_BY_CEP_LOCAL_KEY';
const kGetListAddressByLocalDetailsLocalKey =
    'GET_LISTADDRESS_BY_LOCAL_DETAILS_LOCAL_KEY';

class CepLocalDataSourceImpl implements CepLocalDataSource {
  final LocalService _localService;

  CepLocalDataSourceImpl(this._localService);

  // ========== Operações para Endereco Individual ==========

  @override
  Future<AddressModel?> getAddressFromCache() async {
    try {
      final localAddress = await _localService.get<String>(
        kGetAddressByCepLocalKey,
      );

      if (localAddress == null) return null;

      return AddressModel.fromJson(localAddress);
    } on LocalException catch (e) {
      throw CepLocalException(message: e.message);
    }
  }

  @override
  Future<void> saveAddressToCache(AddressModel address) async {
    try {
      await _localService.set<String>(
        kGetAddressByCepLocalKey,
        address.toJSON(),
      );
    } on LocalException catch (e) {
      throw CepLocalException(message: e.message);
    }
  }

  // ========== Operações para Lista de Endereços ==========

  @override
  Future<List<AddressModel>?> getAddressesListFromCache() async {
    try {
      final localListAddress = await _localService.get<String>(
        kGetListAddressByLocalDetailsLocalKey,
      );

      if (localListAddress == null) return null;

      return (jsonDecode(localListAddress) as List)
          .map((item) => AddressModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } on LocalException catch (e) {
      throw CepLocalException(message: e.message);
    }
  }

  @override
  Future<void> saveAddressesListToCache(List<AddressModel> addressList) async {
    try {
      await _localService.set<String>(
        kGetListAddressByLocalDetailsLocalKey,
        jsonEncode(addressList.map((item) => item.toMap()).toList()),
      );
    } on LocalException catch (e) {
      throw CepLocalException(message: e.message);
    }
  }
}
