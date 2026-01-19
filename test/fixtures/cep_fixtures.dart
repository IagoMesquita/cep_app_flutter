import 'package:cep_app/features/cep/data/models/cep_response_model.dart';
import 'package:cep_app/features/cep/domain/entities/get_cep_details_by_cep_body.dart';
import 'package:cep_app/features/cep/domain/entities/get_ceps_details_by_local_details_body.dart';

const tCepObject = CepResponseModel(
  cep: 'cep',
  logradouro: 'logradouro',
  complemento: 'complemento',
  bairro: 'bairro',
  localidade: 'localidade',
  uf: 'PI',
);

const Map<String, dynamic> tCepApiReponse = {
  'cep': 'cep',
  'logradouro': 'logradouro',
  'complemento': 'complemento',
  'bairro': 'bairro',
  'localidade': 'localidade',
  'uf': 'PI',
};

const String tCepLocalResponse =
    '{"cep":"cep","logradouro":"logradouro","complemento":"complemento","bairro":"bairro","localidade":"localidade","uf":"PI"}';

const tGetCepDetailsByCepBodyRight = GetCepDetailsByCepBody(cep: 'cep');

const tGetCepsDetailByCepBodyRight = GetCepsDetailsByLocalDetailsBody(
  cidade: 'cidade',
  estado: 'estado',
  rua: 'rua',
);
