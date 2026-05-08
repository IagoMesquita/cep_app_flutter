import 'package:equatable/equatable.dart';

class SearchByCepParams extends Equatable {
  final String cep;

  const SearchByCepParams({required this.cep});

  @override
  List<Object?> get props => [cep];
}
