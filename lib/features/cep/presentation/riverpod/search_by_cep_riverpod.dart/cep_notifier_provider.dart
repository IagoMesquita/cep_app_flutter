import 'package:cep_app/features/cep/domain/use_cases/search_address_by_cep.dart';
import 'package:cep_app/features/cep/presentation/riverpod/cep_app_state.dart';
import 'package:cep_app/features/cep/presentation/riverpod/providers/cep_app_provider.dart';
import 'package:cep_app/features/cep/presentation/riverpod/search_by_cep_riverpod.dart/search_by_cep_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider responsável por gerenciar o estado da busca de um CEP individual.
/// Retorna o SearchByCepNotifier tipado com a superclasse selada CepAppState.
final searchByCepNotifierProvider =
    StateNotifierProvider<SearchByCepNotifier, CepAppState>((ref) {
      // Lê o UseCase injetado no arquivo central de dependências (cep_app_provider.dart)
      final SearchAddressByCepInstance = ref.read<SearchAddressByCep>(
        SearchAddressByCepProvider,
      );

      return SearchByCepNotifier(SearchAddressByCepInstance);
    });
