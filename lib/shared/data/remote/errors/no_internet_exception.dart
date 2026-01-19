import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/erros/base_exceptions.dart';

final class NoInternetException  extends BaseExceptions {
  NoInternetException({super.message = ConstStrings.kNoInternetConnectionMessage});
}