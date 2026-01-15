import 'package:cep_app/features/cep/domain/entities/cep_response.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';

const tCepObject = CepResponse(
  bairro: 'bairro',
  cep: 'cep',
  complemento: 'complemento',
  localidade: 'localidade',
  logradouro: 'logradouro',
  uf: 'PI',
);

const tGetCepDetailsByCepBodyRight = GetCepDetailsByCepBody(cep: 'cep');

const tGetCepsDetailByCepBodyRight = GetCepsDetailsByLocalDetailsBody(
  cidade: 'cidade',
  estado: 'estado',
  rua: 'rua'
);