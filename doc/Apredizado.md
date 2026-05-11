## Aprendizado: O Coração Agnóstico (Camada de Domain)

Nesta sessão, analisamos a importância da independência da camada de **Domain** em relação a frameworks.

### Conceitos Chave:
- **Independência de Framework:** O Domain (Entities, UseCases, Repositories Interfaces) deve ser escrito em Dart puro. Evitamos importar `flutter/material.dart` ou `riverpod`.
- **Regra de Ouro:** Se eu decidir trocar o Riverpod pelo BLoC amanhã, meu arquivo de UseCase **não deve sofrer nenhuma alteração**.
- **Testabilidade:** UseCases que dependem apenas de interfaces (Contratos) são facilmente mockados, permitindo um TDD fluido onde testamos comportamentos e não implementações.

### Decisão Arquitetural:
Moveremos a configuração de Dependency Injection (Providers do Riverpod) para fora do Domain, tratando o Riverpod como uma ferramenta de infraestrutura/apresentação.

## Aprendizado: Entidades e UseCases com Regras de Negócio

Nesta sessão, validamos a estrutura da camada de **Domain** e aprofundamos o papel do **UseCase**.

### Conceitos Chave:
- **Value Equality (Equatable):** Entidades precisam de comparação por valor para que testes e gerentes de estado funcionem corretamente.
- **UseCase vs Repository:** O Repository apenas provê dados. O UseCase **decide** se os dados podem ser solicitados. A validação de formato de entrada (ex: Regex de CEP) é uma regra de negócio de processo e deve morar no UseCase.
- **Fail Fast:** Ao validar os dados no UseCase, impedimos que erros cheguem às camadas de infraestrutura (Data/External), economizando recursos.

### Decisão Arquitetural:
Transformamos o UseCase de um simples "repassador de chamadas" em um validador de integridade da regra de negócio, garantindo que o sistema falhe rápido (Fail Fast) caso o input seja inválido.

## Aprendizado: Nomenclatura e Semântica de Erros

Nesta sessão, refinamos a semântica da camada de **Domain**, eliminando termos de infraestrutura e limpando a verbosidade.

### Conceitos Chave:
- **Linguagem Ubíqua:** No Domínio, usamos termos do negócio. Mudamos `Body` (termo técnico de API) para `Params` (termo de lógica/busca).
- **Exceptions vs Failures:** 
    - **Exceptions** (Camada de Data/External): Erros técnicos e brutos (DioException, SqlException).
    - **Failures** (Camada de Domain/Presentation): Erros tratados e amigáveis ao negócio (NotFoundFailure).
- **Concisão de Arquivos:** O caminho das pastas (contexto) já explica o que o arquivo faz. Nomes de arquivos não precisam repetir o nome da pasta (ex: `remote/cep_datasource.dart` em vez de `remote/cep_remote_data_source.dart`).

### Decisão Arquitetural:
Padronizamos o uso de `Params` para entradas de Use Cases e `Failures` para retornos de erro no domínio, garantindo que a camada de negócio seja pura e legível.

## Aprendizado: Semântica de Erros e Evolução da Entidade

Nesta sessão, evoluímos a nomenclatura do sistema para refletir a realidade do negócio e definimos a fronteira entre erros técnicos e erros de negócio.

### Conceitos Chave:
- **AddressEntity:** A entidade representa o conceito central do domínio (um endereço), tornando-se independente do método de busca (seja por CEP ou por logradouro).
- **Exceptions vs. Failures:** 
    - **Exceptions:** Erros de infraestrutura que são "lançados" (camada Data).
    - **Failures:** Erros de negócio que são "retornados" como valores (camada Domain).
- **Params como Cidadãos de Primeira Classe:** Mover parâmetros para uma pasta dedicada em `use_cases/params` limpa a assinatura dos métodos e facilita a manutenção.

### Decisão Arquitetural:
Padronizamos o retorno dos UseCases para usar `Failure` em vez de `Exception`, garantindo que a camada de Presentation trate erros como estados previsíveis da aplicação e não como interrupções abruptas do fluxo.

## Aprendizado: Por que Failures não são Exceptions?

Nesta sessão, discutimos a distinção técnica entre objetos de exceção e objetos de falha no ecossistema Dart/Flutter.

### Conceitos Chave:
- **Interface Exception (Dart):** Uma interface de marcação destinada a objetos que interrompem o fluxo normal do programa (usando `throw`).
- **Failures (Domain):** Objetos de dados puros que representam um estado de erro esperado no negócio. Eles são tratados como valores de retorno (dentro de `Either`) e não como interrupções.
- **Desacoplamento Semântico:** Ao não implementar `Exception` no nosso `BaseFailure`, garantimos que erros de negócio não sejam confundidos com erros técnicos de infraestrutura.

### Decisão Arquitetural:
O `BaseFailure` agora é uma classe Dart pura e independente. Isso força a equipe de desenvolvimento a tratar falhas de domínio através do fluxo funcional (`Either/Left`), reservando o uso de `Exceptions` apenas para a camada de infraestrutura (Data/External).

## Aprendizado: Models e a Ponte entre Camadas (Data Layer)

Nesta sessão, exploramos a implementação do **Model** como uma especialização da **Entity** para a camada de infraestrutura.

### Conceitos Chave:
- **Model vs Entity:** A Entity é o conceito puro. O Model é a implementação técnica que entende de JSON, mapas e persistência.
- **Diferenciação de Camadas:** O Model vive na camada **Data**, permitindo que o **Domain** permaneça sem saber o que é um `jsonDecode` ou um `Map<String, dynamic>`.
- **Construtores Factory:** São fundamentais para a criação flexível de objetos, permitindo lógica de validação e transformação durante a desserialização de dados externos.

### Decisão Arquitetural:
Adotamos a herança de `AddressEntity` para o `AddressModel` visando simplicidade e reuso de código, mantendo a lógica de mapeamento (fromMap/toMap) restrita à camada de Data para proteger o domínio de mudanças nos contratos de APIs externas.