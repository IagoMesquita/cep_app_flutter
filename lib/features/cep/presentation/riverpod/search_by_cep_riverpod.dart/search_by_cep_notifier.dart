import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/search_address_by_cep.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/shared/core/async/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchByCepNotifier extends StateNotifier<CepAppState> {
  final SearchAddressByCep _searchAddressByCep;

  // Iniciamos com o estado base limpo
  SearchByCepNotifier(this._searchAddressByCep)
    : super(const CepStateInitial());

  // Um getter prático caso a UI só queira saber se trava um botão, por exemplo
  bool get isLoading => state is CepStateLoading;

  Future<void> loadAddressByCep(String cep) async {
    // 1. Emitimos o estado de carregamento imediatamente
    state = const CepStateLoading();

    final params = SearchByCepParams(cep: cep);
    final cepEither = await _searchAddressByCep(params);

    // 2. Pattern Matching limpo do resultado
    switch (cepEither) {
      case Left(value: final failure):
        {
          // Usamos o novo Failure que criamos no domínio para o cache
          if (failure is NotInternetWithAdressCacheFailure) {
            state = SearchByCepOfflineSuccessState(
              failure.lastSavedAddress,
              failure.message,
            );
          } else {
            // Qualquer outro erro genérico ou de validação
            state = CepStateError(failure.message);
          }
        }
      case Right(value: final address):
        {
          // Sucesso puro da API ou do banco local padrão
          state = SearchByCepSuccessState(address);
        }
    }
  }
}
