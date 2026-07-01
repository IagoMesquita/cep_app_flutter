import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:cep_app/features/cep/domain/errors/address_failure.dart';
import 'package:cep_app/features/cep/domain/repositories/cep_repository.dart';
import 'package:cep_app/features/cep/domain/use_cases/params/search_by_address_params.dart';
import 'package:cep_app/shared/core/async/either.dart';

class SearchCepsByAddressDetails {
  final CepRepository _cepRepository;

  SearchCepsByAddressDetails(this._cepRepository);

  Future<Either<AddressFailure, List<AddressEntity>>> call(SearchByAddressParams param) async {
    // 1. Sanitização e Validação básica do Estado (UF)
    final normalizedState = param.estado.trim().toUpperCase();

    //2. Valida se o estado tem exatamente 2 caracteres
    if (normalizedState.length != 2) {
      return Left(InvalidAddressParamsFailure());
    }
    
    // 3. Validação preventiva: evita requisições inúteis com campos em branco
    if(param.cidade.trim().isEmpty || param.rua.trim().isEmpty) {
      return Left(AddressFailure(message: 'Os campos Cidade e Rua não podem estar vazios.'));
    }

    // 4. Monta o parâmetro normalizado e limpo para o repositório
    final normalizedParam = SearchByAddressParams(
      estado: normalizedState,
      cidade: param.cidade.trim(),
      rua: param.rua.trim(),
    );
    
    return _cepRepository.getAddressesListByAdress(normalizedParam);
  }
  
}