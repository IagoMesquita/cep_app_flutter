import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_cep_details_by_cep.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/cep_fixtures.dart';
import '../../../../fixtures/mock_cep_repository.dart';

void main() {
  late CepRepository mockCepRepository;
  late GetCepDetailsByCep getCepDetailsByCep;

  setUp(() {
    mockCepRepository = MockCepRepository();
    getCepDetailsByCep = GetCepDetailsByCep(mockCepRepository);

    registerFallbackValue(tGetCepDetailsByCepBodyRight);
  });

  group('should get cep details by cep', () {
    test('success', () async {
      when(() => mockCepRepository.getCepDetailsByCep(any())).thenAnswer(
        (_) async => Right(tCepObject),
      );

      final cepResponse = await getCepDetailsByCep(tGetCepDetailsByCepBodyRight);

      expect(cepResponse, isA<Right>());
    });

    test('fail', () async {
      when(() =>  mockCepRepository.getCepDetailsByCep(any())).thenAnswer(
        (_) async => Left(
          CepException(message: ConstStrings.kDefaultError),
        ) 
      );

      final cepResponseEither = await getCepDetailsByCep(tGetCepDetailsByCepBodyRight);

      expect(cepResponseEither, isA<Left>());
      expect(((cepResponseEither as Left).value as CepException).message, ConstStrings.kDefaultError);
    });
  });
}
