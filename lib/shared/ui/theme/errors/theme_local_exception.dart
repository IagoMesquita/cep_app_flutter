final class ThemeLocalException implements Exception {
  final String message;
  ThemeLocalException({required this.message});
}

//Forma antiga de passar o super
// final class ThemeLocalException extends BaseExceptions {
//  ThemeLocalException({ String? message }) : super(message: message);
//}
