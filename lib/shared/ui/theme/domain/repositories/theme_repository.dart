import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/ui/theme/errors/theme_local_exception.dart';

abstract class ThemeRepository {
  Future<Either<ThemeLocalException, bool>> getIsLightThe();

  Future<Either<ThemeLocalException, void>> setIsLightThemr(bool isLightThe);
}