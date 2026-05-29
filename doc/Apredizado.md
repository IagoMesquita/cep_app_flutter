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
OBS: Para projetos maiores, o uso de ferramentas como Freezed ou JsonSerializable evita erros humanos na escrita manual de strings como 'logradouro'.

## Aprendizado: Repositório como Coordenador e o DIP

Nesta sessão, analisamos o papel do **Repository Implementation** como o mediador entre dados externos e o domínio.

### Conceitos Chave:
- **DIP (Dependency Inversion Principle):** O Repositório não deve depender de implementações de DataSources, mas sim de interfaces. Isso permite trocar a fonte de dados (ex: mudar de SharedPreferences para Isar) sem tocar na lógica do repositório.
- **Single Source of Truth:** O Repositório decide a estratégia de dados (Remote-first, Local-only, etc.). No entanto, para o UseCase (Domínio), não importa de onde o dado veio. Se o dado existe, é um `Right`.
- **Tratamento de Exceções:** DataSources lançam `Exceptions` (erros técnicos). Repositórios capturam essas exceções e as convertem em `Failures` (erros de negócio).

### Decisão Arquitetural:
Reduzimos a complexidade do repositório diminuindo o número de dependências injetadas (agrupando métodos relacionados em DataSources genéricos) e garantimos que o `Either` reflita o sucesso da operação, independentemente se a origem foi remota ou local.
## 1. O Coração Agnóstico (Camada de Domain)

Nesta sessão, analisamos a importância da independência da camada de **Domain** em relação a frameworks e detalhes de implementação.

### Conceitos Chave:
* **Independência de Framework:** O Domain (Entities, UseCases, Repositories Interfaces) deve ser escrito em Dart puro. Evitamos importar `flutter/material.dart` ou `riverpod`.
* **Regra de Ouro:** Se a stack do projeto mudar de Riverpod para BLoC amanhã, os arquivos de UseCase e Entity **não devem sofrer nenhuma alteração**.
* **Value Equality (Equatable):** Entidades precisam de comparação por valor para que testes unitários e gerentes de estado funcionem corretamente, detectando mudanças por conteúdo e não por referência de memória.

### Decisão Arquitetural:
* Mudamos o nome de `CepResponse` (que cheirava a resposta de API) para `AddressEntity`, refletindo a linguagem do negócio.
* Moveremos a configuração de Dependency Injection (Providers do Riverpod) para fora do Domain, tratando o Riverpod como uma ferramenta de infraestrutura/apresentação.

---

## 2. Nomenclatura, Semântica de Erros e UseCases

Refinamos a semântica da camada de Domain, eliminando termos de infraestrutura, limpando a verbosidade e adicionando inteligência aos UseCases.

### Conceitos Chave:
* **Linguagem Ubíqua:** No Domínio, usamos termos do negócio. Mudamos `Body` (termo técnico de protocolo HTTP) para `Params` (termo de lógica/busca), organizados em `domain/use_cases/params/`.
* **Exceptions vs. Failures:** * **Exceptions** (Camada de Data/External): Erros técnicos, brutos e inesperados (ex: `DioException`, `SqlException`). Implementam a interface `Exception` do Dart pois são feitos para serem lançados (`throw`).
    * **Failures** (Camada de Domain/Presentation): Erros tratados e amigáveis ao negócio (ex: `InvalidCepFailure`). São classes Dart puras, tratadas como valores de retorno (dentro de `Either`).
* **Fail Fast (Validação no UseCase):** O Repository apenas provê dados. O UseCase decide se os dados podem ser solicitados. Ao validar o formato do input (Regex do CEP) no UseCase, impedimos requisições desnecessárias à rede.

### Decisão Arquitetural:
* O `BaseFailure` agora é uma classe Dart pura e independente (não implementa `Exception`). Isso força o tratamento de falhas de domínio através do fluxo funcional (`Either/Left`).

---

## 3. Models e a Ponte entre Camadas (Data Layer)

Exploramos a implementação do **Model** como uma especialização da **Entity** para a camada de infraestrutura.

### Conceitos Chave:
* **Model vs Entity:** A Entity é o conceito puro. O Model é a implementação técnica que entende de JSON, mapas e persistência. Ele vive na camada **Data**, protegendo o domínio de mudanças nos contratos de APIs externas.
* **Construtores Factory:** São fundamentais para a criação flexível de objetos, permitindo lógica de validação, higienização de dados (como remover hifens do CEP) e transformação durante a desserialização.

---

## 4. Interfaces e a Resiliência de Dados (DIP)

Analisamos o papel do **Repository Implementation** como o mediador entre dados externos e o domínio, aplicando o princípio da inversão de dependência.

### Conceitos Chave:
* **DIP (Dependency Inversion Principle):** O Repositório não depende de implementações de DataSources, mas sim de interfaces (`abstract interface class`). Isso permite trocar a fonte de dados (mudar de SharedPreferences para Isar/Hive) sem tocar na lógica do repositório.
* **Data Mapper Pattern:** Realizamos a conversão de `Map<String, dynamic>` para `AddressModel` dentro do DataSource, entregando objetos fortemente tipados ao repositório.
* **Coesão de Dependências:** Reduzimos a complexidade do repositório agrupando métodos relacionados em apenas duas "portas": `CepRemoteDataSource` e `CepLocalDataSource`.

```markdown
## Aprendizado Extra: O Significado Semântico do Fluxo de Falha

Discutimos profundamente como alinhar o retorno do padrão `Either` com a expectativa real da regra de negócio do usuário.

### Conceitos Chave:
- **Falha de Intenção:** Se o usuário realiza uma busca pelo identificador "X" e o sistema retorna o identificador "Y" (provindo de um cache de histórico geral), o fluxo principal falhou. Portanto, o resultado deve obrigatoriamente ser canalizado pelo `Left` (Failure).
- **Failures com Estado:** Um objeto de `Failure` não precisa conter apenas uma mensagem de erro string. Ele pode encapsular entidades de domínio (como dados históricos) para que a camada de apresentação decida se deve exibi-los como um fallback visual para o usuário.

### Decisão Arquitetural:
Mantivemos o fluxo de falta de internet operando no `Left`, substituindo o uso de exceções técnicas por um `NoInternetWithCacheFailure` fortemente tipado no domínio, garantindo o transporte seguro do último endereço salvo até a interface do usuário.

## 5. Modelagem de Estados com Tipos Algébricos (Sealed Classes)

Aprofundamos o gerenciamento de estados na camada de Presentation, migrando de arquiteturas baseadas em propriedades booleanas/enums para classes seladas.

### Conceitos Chave:
- **Estados Impossíveis:** Evitamos erros em tempo de execução garantindo que dados de sucesso e estados de carregamento ou erro nunca coexistam na mesma instância de forma inconsistente.
- **Exaustividade (Exhaustiveness Checking):** Ao usar `sealed classes`, o Dart nos obriga via compilador a tratar todos os cenários possíveis de tela no padrão `switch`, aumentando drasticamente a resiliência contra novas manutenções.
- **Casos de Uso Complexos como Estado:** O nosso `NoInternetWithCacheFailure` agora se traduz perfeitamente em um tipo de estado exclusivo (`CepSearchNoInternetWithCache`), permitindo que a interface reaja de forma rica e específica a essa regra de negócio.

## 6. Centralização de Sub-estados em Árvores Seladas Unificadas

Evoluímos o design de controle de estados da camada de apresentação unificando sub-features correlacionadas sob uma única estrutura hierárquica e selada.

### Conceitos Chave:
- **Segregação de Dados em Tipos Concretos:** Eliminamos a necessidade de herança de propriedades mutáveis (`copyWith` na base) e de tipos opcionais/nulos em estados de sucesso. Cada tipo concreto carrega apenas o contrato exato que a UI precisa renderizar.
- **Diferenciação Semântica de Sucesso Local/Remoto:** Criamos distinções explícitas entre dados puros e dados recuperados via mecanismos de contingência (`OfflineSuccess`), facilitando o comportamento reativo de banners e componentes visuais na View.
- **Redução de Código Boilerplate:** A eliminação de múltiplos arquivos de estado e construtores de herança reduz as linhas de código de manutenção da feature em mais de 45%, mantendo a legibilidade arquitetural intacta.
ONDE PAREI: adicionei NotInternetWithCacheFailure. mas ainda nao usei.
