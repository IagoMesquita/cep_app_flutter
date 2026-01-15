import 'package:equatable/equatable.dart';

class GetCepsDetailsByLocalDetailsBody extends Equatable {
  final String estado;
  final String cidade;
  final String rua;

  const GetCepsDetailsByLocalDetailsBody({
    required this.estado,
    required this.cidade,
    required this.rua 
  });
  
  @override
  List<Object?> get props => [estado, cidade, rua];

}