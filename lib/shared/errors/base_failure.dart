import 'package:cep_app/shared/const/const_strings.dart';

base class BaseFailure {
  final String message;

  const BaseFailure({ String? message}) : message = message ?? ConstStrings.kDefaultError;

  
}