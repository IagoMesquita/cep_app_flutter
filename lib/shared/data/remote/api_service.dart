import 'package:cep_app/shared/data/models/api_response_model.dart';

abstract interface class ApiService {
  /// Realiza uma requisição HTTP GET assíncrona para o [endPoint] especificado.
  ///
  /// O parâmetro [endPoint] representa a rota relativa da API.
  /// O parâmetro opcional [queryParams] permite enviar parâmetros de busca ou filtros na URL.
  ///
  /// Retorna um [ApiResponseModel] contendo o status code e o payload de dados em caso de sucesso.
  ///
  /// Throws a [NoInternetException] se o dispositivo perder totalmente o acesso à rede (erro de Socket).
  /// Throws a [ApiException] se o servidor responder com um erro HTTP (400, 401, 500) ou se ocorrer uma falha inesperada.
  Future<ApiResponseModel> get<T>(
    String endPoint, {
    Map<String, dynamic>? queryParams,
  });
}