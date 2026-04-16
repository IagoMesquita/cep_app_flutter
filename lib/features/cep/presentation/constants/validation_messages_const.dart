sealed class ValidationMessagesConst {
  static String notEmpty(String inputLabel) =>
      'Por favor, insira o $inputLabel';

  static String length(String inputLabel, int length) =>
      '$inputLabel n~ao deve exceder $length${length > 1 ? 's' : ''}';
}
