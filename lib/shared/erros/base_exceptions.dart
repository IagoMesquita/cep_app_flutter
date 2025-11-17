import 'package:cep_app/shared/const/const_strings.dart';

base class BaseExceptions  implements Exception {
  final String message;

  const BaseExceptions({ String? message}) : message = message ?? ConstStrings.kDefaultError;

  
}