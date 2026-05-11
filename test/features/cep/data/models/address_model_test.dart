import 'dart:convert';

import 'package:cep_app/features/cep/data/models/address_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/cep_fixtures.dart';

void main() {
  group('AddressModel fromMap', () {
    test('deve criar um objeto válido a partir de um JSON real do ViaCEP', () {
      // Arrange - JSON real simulando resposta da API ViaCEP
      final Map<String, dynamic> viaCepResponse = {
        'cep': '01310-100',
        'logradouro': 'Avenida Paulista',
        'complemento': 'lado ímpar',
        'bairro': 'Bela Vista',
        'localidade': 'São Paulo',
        'uf': 'SP',
      };

      // Act
      final result = AddressModel.fromMap(viaCepResponse);

      // Assert
      expect(result.cep, equals('01310100')); // CEP sem hífen
      expect(result.logradouro, equals('Avenida Paulista'));
      expect(result.complemento, equals('lado ímpar'));
      expect(result.bairro, equals('Bela Vista'));
      expect(result.localidade, equals('São Paulo'));
      expect(result.uf, equals('SP'));
    });

    test('deve remover hífen do CEP ao criar modelo', () {
      // Arrange
      final mapWithHyphen = {
        'cep': '12345-678',
        'logradouro': 'Rua Teste',
        'complemento': '',
        'bairro': 'Bairro Teste',
        'localidade': 'Cidade Teste',
        'uf': 'SP',
      };

      // Act
      final result = AddressModel.fromMap(mapWithHyphen);

      // Assert
      expect(result.cep, equals('12345678'));
      expect(result.cep.contains('-'), isFalse);
    });

    test('deve retornar strings vazias para valores nulos (resiliência)', () {
      // Arrange - Map com valores nulos
      final Map<String, dynamic> mapWithNulls = {
        'cep': null,
        'logradouro': null,
        'complemento': null,
        'bairro': null,
        'localidade': null,
        'uf': null,
      };

      // Act
      final result = AddressModel.fromMap(mapWithNulls);

      // Assert
      expect(result.cep, equals(''));
      expect(result.logradouro, equals(''));
      expect(result.complemento, equals(''));
      expect(result.bairro, equals(''));
      expect(result.localidade, equals(''));
      expect(result.uf, equals(''));
    });

    test('deve funcionar com dados parcialmente nulos', () {
      // Arrange
      final Map<String, dynamic> partialData = {
        'cep': '12345-678',
        'logradouro': 'Rua Completa',
        'complemento': null,
        'bairro': 'Bairro',
        'localidade': null,
        'uf': 'RJ',
      };

      // Act
      final result = AddressModel.fromMap(partialData);

      // Assert
      expect(result.cep, equals('12345678'));
      expect(result.logradouro, equals('Rua Completa'));
      expect(result.complemento, equals(''));
      expect(result.bairro, equals('Bairro'));
      expect(result.localidade, equals(''));
      expect(result.uf, equals('RJ'));
    });

    test('deve converter Map para AddressModel (fixture)', () {
      // Act
      final cepResponse = AddressModel.fromMap(tCepApiReponse);

      // Assert
      expect(cepResponse, equals(tCepObject));
    });
  });

  group('AddressModel toMap', () {
    test('deve gerar um Map com as chaves corretas', () {
      // Arrange
      const addressModel = AddressModel(
        cep: '01310100',
        logradouro: 'Avenida Paulista',
        complemento: 'lado ímpar',
        bairro: 'Bela Vista',
        localidade: 'São Paulo',
        uf: 'SP',
      );

      // Act
      final result = addressModel.toMap();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result.keys, containsAll(['cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf']));
      expect(result['cep'], equals('01310100'));
      expect(result['logradouro'], equals('Avenida Paulista'));
      expect(result['complemento'], equals('lado ímpar'));
      expect(result['bairro'], equals('Bela Vista'));
      expect(result['localidade'], equals('São Paulo'));
      expect(result['uf'], equals('SP'));
    });

    test('deve gerar Map com exatamente 6 chaves', () {
      // Arrange
      const addressModel = AddressModel(
        cep: '12345678',
        logradouro: 'Rua Teste',
        complemento: '',
        bairro: 'Bairro',
        localidade: 'Cidade',
        uf: 'SP',
      );

      // Act
      final result = addressModel.toMap();

      // Assert
      expect(result.length, equals(6));
    });
  });

  group('AddressModel toJSON', () {
    test('deve produzir uma String JSON válida', () {
      // Arrange
      const addressModel = AddressModel(
        cep: '01310100',
        logradouro: 'Avenida Paulista',
        complemento: 'lado ímpar',
        bairro: 'Bela Vista',
        localidade: 'São Paulo',
        uf: 'SP',
      );

      // Act
      final result = addressModel.toJSON();

      // Assert
      expect(result, isA<String>());
      expect(() => jsonDecode(result), returnsNormally);
      
      final decoded = jsonDecode(result) as Map<String, dynamic>;
      expect(decoded['cep'], equals('01310100'));
      expect(decoded['logradouro'], equals('Avenida Paulista'));
      expect(decoded['uf'], equals('SP'));
    });

    test('deve converter AddressModel para JSON (fixture)', () {
      // Act
      final cepJson = tCepObject.toJSON();

      // Assert
      expect(cepJson, equals(tCepLocalResponse));
    });

    test('JSON gerado deve ser válido para reconstruir o modelo', () {
      // Arrange
      const original = AddressModel(
        cep: '12345678',
        logradouro: 'Rua Original',
        complemento: 'Comp',
        bairro: 'Bairro',
        localidade: 'Cidade',
        uf: 'RJ',
      );

      // Act
      final jsonString = original.toJSON();
      final reconstructed = AddressModel.fromJson(jsonString);

      // Assert
      expect(reconstructed, equals(original));
    });
  });

  group('AddressModel fromJson', () {
    test('deve converter JSON para AddressModel', () {
      // Act
      final cepResponse = AddressModel.fromJson(tCepLocalResponse);

      // Assert
      expect(cepResponse, equals(tCepObject));
    });

    test('deve converter String JSON real para modelo', () {
      // Arrange
      const jsonString = '{"cep":"01310-100","logradouro":"Av Paulista","complemento":"","bairro":"Bela Vista","localidade":"São Paulo","uf":"SP"}';

      // Act
      final result = AddressModel.fromJson(jsonString);

      // Assert
      expect(result.cep, equals('01310100')); // Hífen removido
      expect(result.logradouro, equals('Av Paulista'));
      expect(result.uf, equals('SP'));
    });
  });

  group('AddressModel ciclo completo', () {
    test('deve manter dados após ciclo fromMap -> toMap -> fromMap', () {
      // Arrange
      final originalMap = {
        'cep': '01310-100',
        'logradouro': 'Avenida Paulista',
        'complemento': 'lado ímpar',
        'bairro': 'Bela Vista',
        'localidade': 'São Paulo',
        'uf': 'SP',
      };

      // Act
      final model1 = AddressModel.fromMap(originalMap);
      final map2 = model1.toMap();
      final model2 = AddressModel.fromMap(map2);

      // Assert
      expect(model1, equals(model2));
      expect(model2.cep, equals('01310100')); // CEP limpo persiste
    });

    test('deve manter dados após ciclo toJSON -> fromJson', () {
      // Arrange
      const original = AddressModel(
        cep: '98765432',
        logradouro: 'Rua da Paz',
        complemento: 'Apto 101',
        bairro: 'Centro',
        localidade: 'Rio de Janeiro',
        uf: 'RJ',
      );

      // Act
      final json = original.toJSON();
      final reconstructed = AddressModel.fromJson(json);

      // Assert
      expect(reconstructed, equals(original));
      expect(reconstructed.cep, equals(original.cep));
      expect(reconstructed.logradouro, equals(original.logradouro));
    });
  });
}