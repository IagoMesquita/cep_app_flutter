import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_ceps_details_by_local_details.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/cep_fixtures.dart';
import '../../../../fixtures/mock_cep_repository.dart';

void main() {
  late CepRepository mockCepRepository;
  late GetCepsDetailsByLocalDetails getCepsDetailsByLocalDetails;

  setUp(() {
    mockCepRepository = MockCepRepository();
    getCepsDetailsByLocalDetails = GetCepsDetailsByLocalDetails(
      mockCepRepository,
    );

    registerFallbackValue(tGetCepsDetailByCepBodyRight);
  });

  group('should get cep details by local details', () {
    test('success', () async {
      when( 
        () => mockCepRepository.getCepsDetailsByLocalDetails(any()),
      ).thenAnswer((_) async => Right([tCepObject]));

      final listOfCepResponse = await getCepsDetailsByLocalDetails(
        tGetCepsDetailByCepBodyRight,
      );

      expect(listOfCepResponse, isA<Right>());
    });

    test('fail', () async {
      when(
        () => mockCepRepository.getCepsDetailsByLocalDetails(any()),
      ).thenAnswer(
        (_) async => Left(CepException(message: ConstStrings.kDefaultError)),
      );

      final listOfCepResponse = await getCepsDetailsByLocalDetails(
        tGetCepsDetailByCepBodyRight,
      );

      expect(listOfCepResponse, isA<Left>());
      expect(
        (((listOfCepResponse as Left).value) as CepException).message,
        ConstStrings.kDefaultError,
      );
    });
  });
}
