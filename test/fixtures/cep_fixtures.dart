import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_cep_params.dart';

const tCepObject = AddressModel(
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

const tSearchByCepParamsRight =SearchByCepParams(cep: 'cep');
const tSearchSearchByCepParamsLeft =SearchByCepParams(cep: 'cepdeerro');

const tSearchByAddressParamsRight = SearchByAddressParams(
  cidade: 'cidade',
  estado: 'estado',
  rua: 'rua',
);
