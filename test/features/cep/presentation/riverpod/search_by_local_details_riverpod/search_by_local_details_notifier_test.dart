import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_ceps_details_by_local_details.dart';
import 'package:cep_app/features/cep/presentation/riverpod/base_cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_local_details_riverpod/search_by_local_details_notifier.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_local_details_riverpod/search_by_local_details_state.dart';
import 'package:cep_app/shared/const/const_strings.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import '../../../../../fixtures/cep_fixtures.dart';

class MockGetCepDetailsByLocalDetails extends Mock
    implements GetCepsDetailsByLocalDetails {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late GetCepsDetailsByLocalDetails mockGetCepDetailsByLocalDetails;
  late SearchByLocalDetailsNotifier searchByLocalDetailsNotifier;
  late BuildContext mockBuildContext;

  setUp(() {
    mockGetCepDetailsByLocalDetails = MockGetCepDetailsByLocalDetails();
    searchByLocalDetailsNotifier = SearchByLocalDetailsNotifier(
      mockGetCepDetailsByLocalDetails,
    );
    mockBuildContext = MockBuildContext();

    registerFallbackValue(tGetCepsDetailByCepBodyRight);
  });

  stateNotifierTest(
    'should not emit state when no methods ara called',
    actions: (_) {},
    build: () => searchByLocalDetailsNotifier,
    expect: () => [],
  );

  group('Cep Notifier tests', () {
    final searchCepByLocalDetailsResponse = [tCepObject];
    stateNotifierTest(
      'should emit CepStateEnum.loading whan function is called and CepStateEnum.loaded after loadAdressByLocalsDetails is completed',
      build: () => searchByLocalDetailsNotifier,
      setUp: () {
        when(
          () => mockGetCepDetailsByLocalDetails(any()),
        ).thenAnswer((_) async => Right(searchCepByLocalDetailsResponse));
      },
      actions: (_) {
        searchByLocalDetailsNotifier.loadAddressByLocalDetails(
          tGetCepsDetailByCepBodyRight,
          mockBuildContext,
        );
      },

      expect: () => [
        const SearchByLocalDetailsState(
          isLoading: true,
          errorMessage: null,
          state: CepStateEnum.loading,
        ),
        SearchByLocalDetailsState(
          isLoading: false,
          state: CepStateEnum.loaded,
          localDetailsList: searchCepByLocalDetailsResponse,
        ),
      ],
    );

    stateNotifierTest(
      'should emit CepStateEnum.loading when the function is called and CepStateWEnum.error after Details is completed',
      build: () => searchByLocalDetailsNotifier,
      setUp: () {
        when(
          () => mockGetCepDetailsByLocalDetails(any()),
        ).thenAnswer((_) async => Left(CepException()));

        when(() => mockBuildContext.mounted).thenReturn(true);
      },
      actions: (_) async {
        searchByLocalDetailsNotifier.loadAddressByLocalDetails(
          tGetCepsDetailByCepBodyRight,
          mockBuildContext,
        );
      },

      expect: () =>[
        const SearchByLocalDetailsState(
          isLoading: true,
          errorMessage: null,
          state: CepStateEnum.loading,
        ),
        SearchByLocalDetailsState(
          errorMessage: ConstStrings.kDefaultError,
          isLoading: false,
          state: CepStateEnum.error,
        )
      ],
    );
  });
}
