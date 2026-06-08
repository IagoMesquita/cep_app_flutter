import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/shared/errors/base_failure.dart';

base class AddressFailure extends BaseFailure {
  AddressFailure({ super.message });
}

final class InvalidCepFailure extends AddressFailure {
  InvalidCepFailure() : super(message: 'CEP inválido. O CEP deve conter exatamente 8 caracteres numéricos.');
}

final class InvalidAddressParamsFailure extends AddressFailure {
  InvalidAddressParamsFailure() : super(message: 'Estado inválido. O estado deve conter exatamente 2 caracteres.');
}

final class NotInternetWithAdressCacheFailure extends AddressFailure {
  final AddressEntity lastSavedAddress;
  NotInternetWithAdressCacheFailure({required this.lastSavedAddress}) : super(message: 'Sem conexão com a internet. Exibindo última consulta realizada.');
} 

final class NotInternetWithAdressesListCacheFailure extends AddressFailure {
  final List<AddressEntity> lastSavedAddressesList;
  NotInternetWithAdressesListCacheFailure({required this.lastSavedAddressesList}) : super(message: 'Sem conexão com a internet. Exibindo última consulta realizada.');
} 