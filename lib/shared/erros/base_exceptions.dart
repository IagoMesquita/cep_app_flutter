import 'package:cep_app/shared/const/const_strings.dart';

base class BaseExceptions {
  final String message;

  const BaseExceptions({ String? message}) : message = message ?? ConstStrings.kDefaultError;

  
}