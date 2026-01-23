import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/shared/const/const_strings.dart';

final class CepLocalException extends CepException {
  CepLocalException({super.message});
}

final class CepRemoteException extends CepException {
  CepRemoteException({super.message});
}

final class CepInterConnectionException extends CepException {
  final CepResponse? cep;

  CepInterConnectionException({this.cep})
    : super(message: ConstStrings.kNoInternetConnectionMessage);
}
