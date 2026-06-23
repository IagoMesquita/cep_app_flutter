import 'package:cep_app/shared/core/async/either.dart';
import 'package:cep_app/shared/theme/data/datasources/get_theme_local_datasource.dart';
import 'package:cep_app/shared/theme/data/datasources/set_theme_local_datasource.dart';
import 'package:cep_app/shared/theme/domain/errors/theme_failure.dart';
import 'package:cep_app/shared/theme/domain/repositories/theme_repository.dart';
import 'package:cep_app/shared/theme/errors/theme_local_exception.dart';

final class ThemeRepositoryImpl implements ThemeRepository {
  final SetThemeLocalDatasource _setThemeLocalDatasource;
  final GetThemeLocalDatasource _getThemeLocalDatasource;

  ThemeRepositoryImpl(
    this._setThemeLocalDatasource,
    this._getThemeLocalDatasource,
  );

  @override
  Future<Either<ThemeFailure, bool>> getIsLightTheme() async {
    try {
      // 1. O DataSource agora retorna o bool direto (ou joga um throw)
      final isLightTheme = await _getThemeLocalDatasource.getIsLightTheme();
      
      return Right(isLightTheme);
      
    } on ThemeLocalException catch (e) {
      // 2. Interceptamos a Exception técnica e convertemos na Failure de negócio
      return Left(ThemeFailure(message: e.message));
      
    } catch (e) {
      // 3. Fallback para erros totalmente desconhecidos
      return Left(const ThemeFailure(message: 'Erro inesperado ao carregar o tema.'));
    }
  }

  @override
  Future<Either<ThemeFailure, void>> setIsLightTheme(bool isLightTheme) async {
    try {
      // 1. O DataSource executa a operação pura
      await _setThemeLocalDatasource.setIsLightTheme(isLightTheme);
      
      return Right(null);
      
    } on ThemeLocalException catch (e) {
      // 2. Interceptamos e traduzimos
      return Left(ThemeFailure(message: e.message));
      
    } catch (e) {
      return Left(const ThemeFailure(message: 'Erro inesperado ao salvar o tema.'));
    }
  }
}