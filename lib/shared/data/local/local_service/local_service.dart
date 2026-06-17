abstract interface class LocalService {
  /// Recupera um dado persistido localmente através de uma [key].
  ///
  /// Retorna o valor do tipo [T] se encontrado, ou `null` se não existir.
  ///
  /// Throws a [LocalException] se houver uma falha de leitura no hardware ou corrupção do cache.
  Future<T?> get<T>(String key);

  /// Salva um [data] localmente atrelado a uma [key].
  ///
  /// Throws a [LocalException] se o espaço em disco estiver cheio ou o serviço falhar.
  Future<void> set<T>(String key, T data);
}