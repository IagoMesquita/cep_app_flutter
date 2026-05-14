import 'package:cep_app/shared/errors/base_failure.dart';

final class ThemeLocalException extends BaseFailure {
  ThemeLocalException({ super.message });
}

//Forma antiga de passar o super
// final class ThemeLocalException extends BaseExceptions {
//  ThemeLocalException({ String? message }) : super(message: message);
//}

