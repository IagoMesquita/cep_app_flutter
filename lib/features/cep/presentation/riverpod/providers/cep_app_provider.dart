import 'package:cep_app/features/cep/data/data_sources/cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/local/cep_local_data_source_impl.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/cep_remote_data_source_impl.dart';
import 'package:cep_app/features/cep/data/repositories/cep_repository_impl.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/search_address_by_cep.dart';
import 'package:cep_app/features/cep/domain/use_cases/search_ceps_by_address_details.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/domain/providers/api_provider.dart';
import 'package:cep_app/shared/domain/providers/local_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. CAMADA DE DATA (Fontes de Dados Unificadas)
// ==========================================

/// Provider para o DataSource Remoto (Lida com a API ViaCEP)
final cepRemoteDataSourceProvider = Provider<CepRemoteDataSource>(
  (ref) => CepRemoteDataSourceImpl(ref.read<ApiService>(apiProvider)),
);

/// Provider para o DataSource Local (Lida com o SharedPreferences/Cache)
final cepLocalDataSourceProvider = Provider<CepLocalDataSource>(
  (ref) => CepLocalDataSourceImpl(ref.read<LocalService>(localProvider)),
);

// ==========================================
// 2. CAMADA DE DOMÍNIO (Contratos e Casos de Uso)
// ==========================================

/// Provider do Repositório. Perceba que injetamos a INTERFACE (CepRepository)
/// mas instanciamos a IMPLEMENTAÇÃO (CepRepositoryImpl) passando os dois DataSources.
final cepRepositoryProvider = Provider<CepRepository>(
  (ref) => CepRepositoryImpl(
    ref.read<CepRemoteDataSource>(cepRemoteDataSourceProvider),
    ref.read<CepLocalDataSource>(cepLocalDataSourceProvider),
  ),
);

/// Caso de Uso: Busca de CEP direta (Ex: '64200000')
final SearchAddressByCepProvider = Provider<SearchAddressByCep>(
  (ref) => SearchAddressByCep(ref.read<CepRepository>(cepRepositoryProvider)),
);

/// Caso de Uso: Busca de CEP por Endereço (Estado, Cidade, Rua)
final getCepDetailsByLocalDetailsProvider =
    Provider<SearchCepsByAddressDetails>(
      (ref) => SearchCepsByAddressDetails(
        ref.read<CepRepository>(cepRepositoryProvider),
      ),
    );
