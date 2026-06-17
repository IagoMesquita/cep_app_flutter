enum ErrorStatus {
  unauthorized,
  noConnection,
  badRequest,
  internalServerError,
  unknown,
}

final class ApiException implements Exception {
  final String identifier;
  final ErrorStatus errorStatus;
  final int? statusCode;
  final String message;


  ApiException({
    required this.identifier,
    required this.errorStatus,
     this.statusCode,
    required this.message,
  });
}
