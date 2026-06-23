import 'package:cep_app/shared/data/local/errors/local_exception.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';
import 'package:cep_app/shared/theme/data/datasources/get_theme_local_datasource.dart';
import 'package:cep_app/shared/theme/errors/theme_local_exception.dart';

abstract class SetThemeLocalDatasource {
  /// Persiste a preferência de tema do usuário no dispositivo.
  ///
  /// Throws a [ThemeLocalException] se o serviço de cache falhar na gravação.
  Future<void> setIsLightTheme(bool isLightTheme);
}

final class SetThemeLocalDatasourceImpl implements SetThemeLocalDatasource {
  final LocalService _localService;

  SetThemeLocalDatasourceImpl(this._localService);

  @override
  Future<void> setIsLightTheme(bool isLightTheme) async {
    try {
      await _localService.set<bool>(IS_LIGHT_THEME_KEY, isLightTheme);
    } on LocalException catch (e) {
      throw ThemeLocalException(message: 'Erro ao salvar a preferência de tema.');
    } catch (e) {
      throw ThemeLocalException(message: 'Erro inesperado ao salvar o tema.');
    }
  }
}
