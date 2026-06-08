import 'package:cep_app/features/cep/domain/use_cases/get_ceps_details_by_local_details.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/providers/cep_app_provider.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_local_details_riverpod/search_by_local_details_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider responsável por gerenciar o estado da busca de lista de CEPs por endereço.
/// Retorna o SearchByLocalDetailsNotifier tipado com a superclasse selada CepAppState.
final searchByLocalDetailsNotifierProvider =
    StateNotifierProvider<
      SearchByLocalDetailsNotifier,
      CepAppState
    >((ref) {
      // Lê o UseCase injetado no arquivo central de dependências (cep_app_provider.dart)
      final getCepDetailsByLocalDetailsInstance = ref
          .read<GetCepsDetailsByLocalDetails>(getCepDetailsByLocalDetailsProvider);

      return SearchByLocalDetailsNotifier(getCepDetailsByLocalDetailsInstance);
    });
