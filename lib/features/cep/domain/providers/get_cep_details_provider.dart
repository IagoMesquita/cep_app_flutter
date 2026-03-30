import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_cep_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_local_details_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_local_details_remote_data_source.dart';
import 'package:cep_app/features/cep/data/repositories/cep_repository_impl.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_cep_details_by_cep.dart';
import 'package:cep_app/features/cep/domain/use_cases/get_ceps_details_by_local_details.dart';
import 'package:cep_app/shared/data/local/local_service/local_service.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/domain/providers/api_provider.dart';
import 'package:cep_app/shared/domain/providers/local_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///----- Pelo CEP
final getCepDetailsByCepRemoteDataSource =
    Provider<GetCepDetailsByCepRemoteDataSource>(
      (ref) => GetCepDetailsByCepRemoteDataSourceImpl(
        ref.read<ApiService>(apiProvider),
      ),
    );

final getCepDetailsByCepLocalDataSource =
    Provider<GetCepDetailsByCepLocalDataSource>(
      (ref) => GetCepDetailsByCepLocalDataSourceImpl(
        ref.read<LocalService>(localProvider),
      ),
    );

/// ----- Pelo Endereco
final getCepDetailsByLocalRemoteDataSource =
    Provider<GetCepDetailsByLocalRemoteDataSource>(
      (ref) => GetCepDetailsByLocalDetailsRemoteDataSourceImpl(
        ref.read<ApiService>(apiProvider),
      ),
    );

final getCepDetailsByLocalDetailsLocalDataSource =
    Provider<GetCepDetailsByLocalDetailsLocalDataSource>(
      (ref) => GetCepDetailsByLocalDetailsLocalDataSourceImpl(
        ref.read<LocalService>(localProvider),
      ),
    );

/// Instacia Repository

final cepRepository = Provider<CepRepository>(
  (ref) => CepRepositoryImpl(
    ref.read<GetCepDetailsByCepRemoteDataSource>(
      getCepDetailsByCepRemoteDataSource,
    ),
    ref.read<GetCepDetailsByCepLocalDataSource>(
      getCepDetailsByCepLocalDataSource,
    ),
    ref.read<GetCepDetailsByLocalRemoteDataSource>(
      getCepDetailsByLocalRemoteDataSource,
    ),
    ref.read<GetCepDetailsByLocalDetailsLocalDataSource>(
      getCepDetailsByLocalDetailsLocalDataSource,
    ),
  ),
);

// Duvidas: Por que esse Providar. Nao ja fizemos a implementacao
// do repository no data que 'e o que e usado em presentarion. O que significa esse repository provider?

// E nesses metodos abaixo, para ja ser nossas usecase chamando repository?

final getCepDetailsByCep = Provider<GetCepDetailsByCep>(
  (ref) => GetCepDetailsByCep(ref.read<CepRepository>(cepRepository)),
);

final getCepDetailsByLocalDetails = Provider<GetCepsDetailsByLocalDetails>(
  (ref) => GetCepsDetailsByLocalDetails(ref.read<CepRepository>(cepRepository)),
);
