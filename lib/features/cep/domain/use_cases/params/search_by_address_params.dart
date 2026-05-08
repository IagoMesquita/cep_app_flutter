import 'package:equatable/equatable.dart';

class SearchByAddressParams extends Equatable {
  final String estado;
  final String cidade;
  final String rua;

  const SearchByAddressParams({
    required this.estado,
    required this.cidade,
    required this.rua 
  });
  
  @override
  List<Object?> get props => [estado, cidade, rua];

}