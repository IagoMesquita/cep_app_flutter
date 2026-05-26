import 'package:cep_app/features/cep/data/data_sources/cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';
import 'package:cep_app/shared/data/remote/errors/no_internet_exception.dart';

class CepRemoteDataSourceImpl implements CepRemoteDataSource {
  final ApiService _apiService;

  CepRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<CepRemoteException, List<AddressModel>>>
  getAddressesListByAddress(SearchByAddressParams addressParams) async {
    final listAddressesEither = await _apiService.get<List>(
      '/${addressParams.estado}/${addressParams.cidade}/${addressParams.rua}/json/',
    );

    switch (listAddressesEither) {
      case Left(value: final l):
        return switch (l.errorStatus) {
          ErrorStatus.noConnection => throw NoInternetException(),
          ErrorStatus.badRequest => Left(
            CepRemoteException(message: l.message!),
          ),
          _ => Left(CepRemoteException(message: l.message)),
        };
      case Right(value: final r):
        // CORREÇÃO: Mapeando explicitamente para AddressModel (camada de Data)
        return Right(
          (r.data as List)
              .map(
                (cepResponse) =>
                    AddressModel.fromMap(cepResponse as Map<String, dynamic>),
              )
              .toList(),
        );
    }
  }

  @override
  Future<Either<CepRemoteException, AddressModel>> getAddressByCep(
    SearchByCepParams cepParam,
  ) async {
    final addressEither = await _apiService.get('/${cepParam.cep}/json/');

    switch (addressEither) {
      case Left(value: final l):
        return switch (l.errorStatus) {
          ErrorStatus.noConnection => throw NoInternetException(),
          ErrorStatus.badRequest => Left(CepRemoteException(message: l.message)),
          _ => Left(CepRemoteException(message: l.message)),
        };
        case Right(value: final r):
          return Right(AddressModel.fromMap(r.data));
    }
  }
}
