import 'package:cep_app/features/cep/data/data_sources/local/get_cep_details_by_local_details_local_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/remote/get_cep_details_by_cep_remote_data_source.dart';
import 'package:cep_app/features/cep/domain/providers/get_cep_details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final providerContainer = ProviderContainer();

  late GetCepDetailsByCepRemoteDataSource getCepRemoteDataSource;
  late GetCepDetailsByLocalDetailsLocalDataSource getCelLocalDataSource;

  setUp(() {
    getCepRemoteDataSource = providerContainer.read<GetCepDetailsByCepRemoteDataSource>(getCepDetailsByCepRemoteDataSource);
    getCelLocalDataSource = providerContainer.read<GetCepDetailsByLocalDetailsLocalDataSource>(getCepDetailsByLocalDetailsLocalDataSource);
  });

  test('getCepRemoteDataSource is a GetCepDetailsByCepRemoteDataSource', () {
    expect(getCepRemoteDataSource, isA<GetCepDetailsByCepRemoteDataSource>());

  });

    test('getCelLocalDataSource is a GetCepDetailsByLocalDetailsLocalDataSource', () {
    expect(getCelLocalDataSource, isA<GetCepDetailsByLocalDetailsLocalDataSource>());

  });
}
