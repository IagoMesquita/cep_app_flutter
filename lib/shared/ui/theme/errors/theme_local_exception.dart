import 'package:cep_app/shared/erros/base_exceptions.dart';

final class ThemeLocalException extends BaseExceptions {
  ThemeLocalException({ super.message });
}

//Forma antiga de passar o super
// final class ThemeLocalException extends BaseExceptions {
//  ThemeLocalException({ String? message }) : super(message: message);
//}

