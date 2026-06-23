import 'package:cep_app/shared/core/async/either.dart';
import 'package:cep_app/shared/theme/domain/errors/theme_failure.dart';

abstract class ThemeRepository {
  Future<Either<ThemeFailure, bool>> getIsLightTheme();

  Future<Either<ThemeFailure, void>> setIsLightTheme(bool isLightThe);
}