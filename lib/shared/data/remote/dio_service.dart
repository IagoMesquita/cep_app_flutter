import 'dart:developer';
import 'dart:io';

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
  }) async {
    try {
      // Desestruturando Response que vem do DIO
      final Response(:data, :statusCode, :statusMessage) = await _dio.get(
        endPoint,
        queryParameters: queryParams,
      );

      return Right(
        ApiResponseModel<T>(
          data: data,
          statusCode: statusCode,
          statusMessage: statusMessage,
        ),
      );
      // Erro de falha na internet ao fazer uma req http
    } on SocketException catch (error, st) {
      const identifier = 'Socket Exception on Get Request';
      log(identifier, error: error, stackTrace: st);

      return Left(
        ApiException(
          identifier: identifier,
          statusCode: 1, //Status code do front. Documentar para a equipe.
          errorStatus: ErrorStatus.noConnection,
        ),
      );
    }
  }
}
