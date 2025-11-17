import 'package:cep_app/shared/data/async/either.dart';
import 'package:cep_app/shared/data/models/api_response_model.dart';
import 'package:cep_app/shared/data/remote/api_service.dart';
import 'package:cep_app/shared/data/remote/errors/api_exception.dart';
import 'package:dio/dio.dart';

final class DioService implements ApiService {
  final Dio _dio;

  DioService(this._dio);

  @override
  Future<Either<ApiException, ApiResponseModel>> get<T>(
    String endPoint, {
    Map<String, dynamic>? queryParams,
  }) {
    try {
      // Desestruturando Response que vem do DIO
      final Response(:data, :statusCode, :statusMessage) = await _dio.get(endPoint, queryParameters: queryParams);
    } catch (e) {}
  }
}
