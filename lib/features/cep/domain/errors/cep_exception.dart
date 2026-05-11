import 'package:cep_app/shared/erros/base_exceptions.dart';

base class AddressFailure extends BaseExceptions {
  AddressFailure({ super.message });
}

final class InvalidCepFailure extends AddressFailure {
  InvalidCepFailure() : super(message: 'CEP inválido. O CEP deve conter exatamente 8 caracteres numéricos.');
}

final class InvalidAddressParamsFailure extends AddressFailure {
  InvalidAddressParamsFailure() : super(message: 'Estado inválido. O estado deve conter exatamente 2 caracteres.');
}