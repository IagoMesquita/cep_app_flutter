import 'package:cep_app/shared/data/local/errors/local_exception.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';
import 'package:cep_app/shared/ui/theme/errors/theme_local_exception.dart';

abstract class GetThemeLocalDatasource {
  /// Recupera o estado do tema salvo no dispositivo.
  ///
  /// Retorna `true` se for Light Theme, ou `false` se for Dark Theme (ou se não houver registro).
  ///
  /// Throws a [ThemeLocalException] se o serviço de cache falhar na leitura.
  Future<bool> getIsLightTheme();
}

const IS_LIGHT_THEME_KEY = 'IS_LIGHT_THEME_KEY';

final class GetThemeLocalDatasourceImpl implements GetThemeLocalDatasource {
  final LocalService _localService;

  GetThemeLocalDatasourceImpl(this._localService);

  @override
  Future<bool> getIsLightTheme() async {
    try {
      final isLightTheme = await _localService.get(IS_LIGHT_THEME_KEY);

      return isLightTheme ?? false;
    } on LocalException catch (e) {
      // Capturamos o erro genérico do serviço e traduzimos para uma exceção específica da Feature
      throw ThemeLocalException(
        message: 'Erro ao carregar a preferência de tema.',
      );
    } catch (e) {
      throw ThemeLocalException(message: 'Erro inesperado ao ler o tema.');
    }
  }
}
