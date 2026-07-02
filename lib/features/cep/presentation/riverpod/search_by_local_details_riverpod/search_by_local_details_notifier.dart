import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/search_ceps_by_address_details.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/shared/core/async/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchByLocalDetailsNotifier extends StateNotifier<CepAppState> {
  final SearchCepsByAddressDetails _searchCepsByAddressDetails;

  SearchByLocalDetailsNotifier(this._searchCepsByAddressDetails)
    : super(const CepStateInitial());

  bool get isLoading => state is CepStateLoading;

  Future<void> loadAddressByLocalDetails({
    required String estado,
    required String cidade,
    required String rua,
  }) async {
    state = const CepStateLoading();

    final params = SearchByAddressParams(
      estado: estado,
      cidade: cidade,
      rua: rua,
    );

    final cepEither = await _searchCepsByAddressDetails(params);

    switch (cepEither) {
      case Left(value: final failure):
        if (failure is NotInternetWithAddressesListCacheFailure) {
          state = SearchByLocalDetailsOfflineSuccessState(
            failure.lastSavedAddressesList,
            failure.message,
          );
        } else {
          state = CepStateError(failure.message);
        }

      case Right(value: final addressesList):
        {
          // Tratamento elegante para lista vazia retornada pela API
          if (addressesList.isEmpty) {
            state = const CepStateNoResult(
              'Nenhum endereço encontrado para os dados informados.',
            );
          } else {
            state = SearchByLocalDetailsSuccessState(addressesList);
          }
        }
    }
  }
}
