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