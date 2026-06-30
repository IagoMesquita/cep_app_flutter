
/// Exceção lançada quando ocorre um erro técnico ou falha de negócio
/// na comunicação com o servidor remoto de CEP.
final class CepLocalException implements Exception {
  final String message;
  CepLocalException({required this.message});
}

/// Exceção lançada quando ocorre uma falha na leitura ou escrita
/// do cache local do dispositivo referente aos dados de CEP.
final class CepRemoteException implements Exception {
  final String message;
  CepRemoteException({required this.message});
}
