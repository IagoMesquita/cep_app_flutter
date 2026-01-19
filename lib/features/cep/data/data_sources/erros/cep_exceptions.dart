import 'package:cep_app/shared/erros/base_exceptions.dart';

base class CepException  extends BaseExceptions {
  CepException({ super.message });
}

final class CepLocalException extends CepException {
  CepLocalException({ super.message });
}

final class CepRemoteException extends CepException {
  CepRemoteException({ super.message };)
}