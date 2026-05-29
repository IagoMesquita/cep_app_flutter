import 'package:cep_app/features/cep/domain/entities/address_entity.dart';
import 'package:equatable/equatable.dart';

/// Superclasse selada para o gerenciamento de estados da Feature CEP.
/// Garante imunidade a estados impossíveis e tipagem estrita na UI.
sealed class CepAppState extends Equatable {
  const CepAppState();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// ESTADOS GERAIS (Compartilhados por ambas as sub-features se necessário)
// ============================================================================

/// Estado Inicial: Formulários limpos e prontos para interação.
final class CepStateInitial extends CepAppState {
  const CepStateInitial();
}

/// Estado de Carregamento: Processamento ativo (Garante que a UI mostre o Shimmer/Loading)
final class CepStateLoading extends CepAppState {
  const CepStateLoading();
}

/// Estado de Erro Crítico: Falha na operação onde não há dados de fallback.
final class CepStateError extends CepAppState {
  final String _message;

  const CepStateError(this._message);

  @override
  List<Object?> get props => [_message];
}

/// Estado Sem Resultados: A busca foi concluída com sucesso na rede, mas a API retornou vazio.
final class CepStateNoResult extends CepAppState {
  final String _message;

  const CepStateNoResult(this._message);

  @override
  List<Object?> get props => [_message];
}

// ============================================================================
// ESTADOS ESPECÍFICOS: BUSCA POR CEP INDIVIDUAL
// ============================================================================

/// Sucesso na busca por CEP que retorna um endereco. Entretém o objeto AddressEntity puro e não-nulo.
final class SearchByCepSucessState extends CepAppState {
  final AddressEntity address;

  const SearchByCepSucessState(this.address);

  @override
  List<Object?> get props => [address];
}

/// Fallback offline para busca de CEP: O fluxo falhou por falta de rede,
/// mas entrega com segurança o último registro persistido em cache.
final class SearchByCepOfflineSucessState extends CepAppState {
  final AddressEntity _lastAddress;
  final String _warningMessage;

  const SearchByCepOfflineSucessState(this._lastAddress, this._warningMessage);

  @override
  List<Object?> get props => [_lastAddress, _warningMessage];
}

// ============================================================================
// ESTADOS ESPECÍFICOS: BUSCA POR DETALHES LOCAIS (ENDEREÇO)
// ============================================================================

/// Sucesso na busca por Endereço. Entrega uma lista tipada e limpa.
final class SearchByLocalDetailsSucsessState extends CepAppState {
  final List<AddressEntity> _addressesList;

  const SearchByLocalDetailsSucsessState(this._addressesList);

  @override
  List<Object?> get props => [_addressesList];
}

/// Fallback offline para lista de endereços.
final class SearchByLocalDetailsOfflineSucessState extends CepAppState {
  final List<AddressEntity> _addressesList;
  final String _warningMessage;

  const SearchByLocalDetailsOfflineSucessState(
    this._addressesList,
    this._warningMessage,
  );

  @override
  List<Object?> get props => [_addressesList, _warningMessage];
}
