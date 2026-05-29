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
  final String message;

  const CepStateError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado Sem Resultados: A busca foi concluída com sucesso na rede, mas a API retornou vazio.
final class CepStateNoResult extends CepAppState {
  final String message;

  const CepStateNoResult(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// ESTADOS ESPECÍFICOS: BUSCA POR CEP INDIVIDUAL
// ============================================================================

/// Sucesso na busca por CEP que retorna um endereco. Entretém o objeto AddressEntity puro e não-nulo.
final class SearchByCepSuccessState extends CepAppState {
  final AddressEntity address;

  const SearchByCepSuccessState(this.address);

  @override
  List<Object?> get props => [address];
}

/// Fallback offline para busca de CEP: O fluxo falhou por falta de rede,
/// mas entrega com segurança o último registro persistido em cache.
final class SearchByCepOfflineSuccessState extends CepAppState {
  final AddressEntity lastAddress;
  final String warningMessage;

  const SearchByCepOfflineSuccessState(this.lastAddress, this.warningMessage);

  @override
  List<Object?> get props => [lastAddress, warningMessage];
}

// ============================================================================
// ESTADOS ESPECÍFICOS: BUSCA POR DETALHES LOCAIS (ENDEREÇO)
// ============================================================================

/// Sucesso na busca por Endereço. Entrega uma lista tipada e limpa.
final class SearchByLocalDetailsSuccessState extends CepAppState {
  final List<AddressEntity> addressesList;

  const SearchByLocalDetailsSuccessState(this.addressesList);

  @override
  List<Object?> get props => [addressesList];
}

/// Fallback offline para lista de endereços.
final class SearchByLocalDetailsOfflineSuccessState extends CepAppState {
  final List<AddressEntity> addressesList;
  final String warningMessage;

  const SearchByLocalDetailsOfflineSuccessState(
    this.addressesList,
    this.warningMessage,
  );

  @override
  List<Object?> get props => [addressesList, warningMessage];
}
