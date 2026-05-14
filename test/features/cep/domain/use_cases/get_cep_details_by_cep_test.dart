import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_cep_details_by_cep.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
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

    registerFallbackValue(tSearchByCepParamsRight);
  });

  group('Validação de CEP', () {
    test('Deve retornar InvalidCepFailure quando o CEP tiver menos de 8 caracteres', () async {
      const invalidParam = SearchByCepParams(cep: '1234567');

      final result = await getCepDetailsByCep(invalidParam);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<InvalidCepFailure>());
    });

    test('Deve retornar InvalidCepFailure quando o CEP tiver mais de 8 caracteres', () async {
      const invalidParam = SearchByCepParams(cep: '123456789');

      final result = await getCepDetailsByCep(invalidParam);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<InvalidCepFailure>());
    });

    test('Deve retornar InvalidCepFailure quando o CEP contiver caracteres não numéricos', () async {
      const invalidParam = SearchByCepParams(cep: '1234567a');

      final result = await getCepDetailsByCep(invalidParam);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<InvalidCepFailure>());
    });

    test('Deve retornar InvalidCepFailure quando o CEP contiver hífens', () async {
      const invalidParam = SearchByCepParams(cep: '12345-678');

      final result = await getCepDetailsByCep(invalidParam);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<InvalidCepFailure>());
    });

    test('Deve retornar InvalidCepFailure quando o CEP estiver vazio', () async {
      const invalidParam = SearchByCepParams(cep: '');

      final result = await getCepDetailsByCep(invalidParam);

      expect(result, isA<Left>());
      expect((result as Left).value, isA<InvalidCepFailure>());
    });
  });

  group('Cenários de sucesso e falha do repository', () {
    test('Deve retornar CepResponse quando o CEP for válido e repository retornar sucesso', () async {
      const validParam = SearchByCepParams(cep: '12345678');
      
      when(() => mockCepRepository.getCepDetailsByCep(any())).thenAnswer(
        (_) async => Right(tCepObject),
      );

      final result = await getCepDetailsByCep(validParam);

      expect(result, isA<Right>());
      expect((result as Right).value, equals(tCepObject));
      verify(() => mockCepRepository.getCepDetailsByCep(validParam)).called(1);
    });

    test('Deve retornar AddressFailure quando o repository falhar', () async {
      const validParam = SearchByCepParams(cep: '87654321');
      
      when(() => mockCepRepository.getCepDetailsByCep(any())).thenAnswer(
        (_) async => Left(
          AddressFailure(message: ConstStrings.kDefaultError),
        ),
      );

      final result = await getCepDetailsByCep(validParam);

      expect(result, isA<Left>());
      expect(
        ((result as Left).value as AddressFailure).message,
        ConstStrings.kDefaultError,
      );
      verify(() => mockCepRepository.getCepDetailsByCep(validParam)).called(1);
    });

    test('Não deve chamar o repository quando o CEP for inválido', () async {
      const invalidParam = SearchByCepParams(cep: 'invalid');

      await getCepDetailsByCep(invalidParam);

      verifyNever(() => mockCepRepository.getCepDetailsByCep(any()));
    });
  });
}
