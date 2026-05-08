import 'package:cep_app/features/cep/data/models/cep_response_model.dart';
import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/shared/const/const_strings.dart';

final class CepLocalException extends CepException {
  CepLocalException({super.message});
}

final class CepRemoteException extends CepException {
  CepRemoteException({super.message});
}

final class CepInterConnectionException extends CepException {
  final AddressEntity? cep;

  CepInterConnectionException({this.cep})
    : super(message: ConstStrings.kNoInternetConnectionMessage);
}

final class LocalDetailsInternetConnectionException extends CepException {
  final List<AddressModel>? cepList;

  LocalDetailsInternetConnectionException({this.cepList})
    : super(message: ConstStrings.kNoInternetConnectionMessage);
}
