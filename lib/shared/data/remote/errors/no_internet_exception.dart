import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/errors/base_failure.dart';

final class NoInternetException  extends BaseFailure {
  NoInternetException({super.message = ConstStrings.kNoInternetConnectionMessage});
}