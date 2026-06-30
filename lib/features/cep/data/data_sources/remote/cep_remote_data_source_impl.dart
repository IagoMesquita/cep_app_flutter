import 'package:cep_app/features/cep/data/data_sources/cep_remote_data_source.dart';
import 'package:cep_app/features/cep/data/data_sources/erros/cep_exceptions.dart';
import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';

class CepRemoteDataSourceImpl implements CepRemoteDataSource {
  final ApiService _apiService;

  CepRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<AddressModel>> getAddressesListByAddress(
    SearchByAddressParams addressParams,
  ) async {
    try {
      // 1. O retorno agora vem direto como o modelo de resposta de sucesso
      final response = await _apiService.get<List>(
        '/${addressParams.estado}/${addressParams.cidade}/${addressParams.rua}/json/',
      );
      // 2. Mapeamento direto e limpo do sucesso
      return (response.data as List)
          .map(
            (cepResponse) =>
                AddressModel.fromMap(cepResponse as Map<String, dynamic>),
          )
          .toList();
    } on ApiException catch (e) {
      // 3. Captura o erro genérico da API e lança a exceção específica desta Feature
      throw CepRemoteException( message: e.message);
    }
    // Nota: O NoInternetException passa direto por aqui e borbulha até o Repository!
  }

  @override
  Future<AddressModel> getAddressByCep(
    SearchByCepParams cepParam,
  ) async {
    try {
      final response = await _apiService.get('/${cepParam.cep}/json/');
      return AddressModel.fromMap(response.data as Map<String, dynamic>);
    } on ApiException catch (e) {
      throw CepRemoteException(message: e.message);
    }

    
  }
}
