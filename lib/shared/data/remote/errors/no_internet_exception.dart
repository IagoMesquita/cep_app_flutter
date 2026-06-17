import 'package:cep_app/shared/const/const_strings.dart';

final class NoInternetException  implements Exception {
  final String message;
  NoInternetException({ this.message = ConstStrings.kNoInternetConnectionMessage});
}