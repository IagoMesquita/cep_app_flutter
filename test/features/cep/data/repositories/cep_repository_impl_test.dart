import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/models/cep_response_model.dart';
import 'package:cep_app/features/cep/data/repositories/cep_repository_impl.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/cep_fixtures.dart';

class MockGetCepDetailsByCepRemoteDataSource extends Mock
    implements GetCepDetailsByCepRemoteDataSource {}

class MockeGetCepDetailsByCepLocalDataSource extends Mock
    implements GetCepDetailsByCepLocalDataSource {}

void main() {
  late GetCepDetailsByCepRemoteDataSource
  mockGetCepDetailsByCepRemoteDataSource;
  late GetCepDetailsByCepLocalDataSource mockeGetCepDetailsByCepLocalDataSource;
  late CepRepository cepRepository;

  setUp(() {
    mockGetCepDetailsByCepRemoteDataSource =
        MockGetCepDetailsByCepRemoteDataSource();
    mockeGetCepDetailsByCepLocalDataSource =
        MockeGetCepDetailsByCepLocalDataSource();

    cepRepository = CepRepositoryImpl(
      mockGetCepDetailsByCepRemoteDataSource,
      mockeGetCepDetailsByCepLocalDataSource,
    );

    registerFallbackValue(tGetCepDetailsByCepBodyRight);
    registerFallbackValue(tCepObject);
  });

  group('get cep by cep', () {
    test('success', () async {
      when(
        () => mockGetCepDetailsByCepRemoteDataSource(any()),
      ).thenAnswer((_) async => Right(tCepObject));

      when(
        () => mockeGetCepDetailsByCepLocalDataSource.set(any()),
      ).thenAnswer((_) async => Right(null));

      final cepEitherResponse = await cepRepository.getCepDetailsByCep(
        tGetCepDetailsByCepBodyRight,
      );

      expect(cepEitherResponse, isA<Right>());
      expect(
        ((cepEitherResponse as Right).value as CepResponseModel),
        equals(tCepObject),
      );
    });

    test('no connection returns cached cep', () async {
      when(
        () => mockGetCepDetailsByCepRemoteDataSource(any()),
      ).thenThrow(NoInternetException());
      when(
        () => mockeGetCepDetailsByCepLocalDataSource.get(),
      ).thenAnswer((_) async => Right(tCepObject));

      final cepEitherResponse = await cepRepository.getCepDetailsByCep(
        tGetCepDetailsByCepBodyRight,
      );

      expect(cepEitherResponse, isA<Left>());

      expect(
        ((cepEitherResponse as Left).value as CepInterConnectionException).cep,
        equals(tCepObject),
      );
    });
    test('remote and local fail', () async {
      const kErrorMessage = 'Error loading cep';

      when(
        () => mockGetCepDetailsByCepRemoteDataSource(any()),
      ).thenThrow(NoInternetException());
      when(() => mockeGetCepDetailsByCepLocalDataSource.get()).thenAnswer(
        (_) async => Left(CepLocalException(message: kErrorMessage)),
      );

      final cepEitherResponse = await cepRepository.getCepDetailsByCep(
        tGetCepDetailsByCepBodyLeft,
      );

      expect(cepEitherResponse, isA<Left>());
      expect(
        ((cepEitherResponse as Left).value as CepLocalException).message,
        equals(kErrorMessage),
      );
    });
  });
}
