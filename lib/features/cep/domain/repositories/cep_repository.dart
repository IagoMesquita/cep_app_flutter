import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';
import 'package:cep_app/features/cep/domain/errors/cep_exception.dart';
import 'package:cep_app/shared/data/async/either.dart';

abstract class CepRepository {
  Future<Either<CepException, CepResponse>> getCepDetailsByCep(
    GetCepDetailsByCepBody body,
  );

  Future<Either<CepException, List<CepResponse>>> getCepsDetailsByLocalDetails(
    GetCepsDetailsByLocalDetailsBody body,
  );
}
