# 🏛️ Decisões Arquiteturais: Gestão de Fluxo e Tratamento de Erros

Este documento unifica e padroniza as diretrizes de tratamento de exceções, falhas e aplicação de programação funcional (`Either`) no projeto.

---

## 🛑 1. Diferença Cirúrgica: Exception vs. Failure

No ecossistema deste projeto, erros mudam de papel conforme cruzam as fronteiras das camadas arquiteturais.

### 💥 Exceptions (Camada de Data / Infraestrutura)
* **O que são:** Erros estritamente técnicos, sistêmicos ou de infraestrutura (Ex: timeout de rede, perda de pacotes, erro de escrita em disco, parse de JSON inválido).
* **Comportamento:** São **implícitas e assíncronas**. Elas devem ser disparadas nativamente usando a palavra-chave `throw`.
* **Exemplos do projeto:** `ApiException`, `NoInternetException`, `CepRemoteException`, `CepLocalException`.

### ⚠️ Failures (Camada de Domain / Negócio)
* **O que são:** Representações de anomalias de negócio orientadas ao usuário final. Elas traduzem o "caos técnico" da infraestrutura em mensagens amigáveis e cenários de contingência.
* **Comportamento:** São **explícitas e seguras**. Elas nunca usam `throw`;` viajam encapsuladas no lado esquerdo (`Left`) do tipo `Either`.
* **Exemplos do projeto:** `InvalidCepFailure`, `NotInternetWithAdressCacheFailure`.

---

## 🔀 2. A Regra de Ouro do `Either`

O `Either` é uma ferramenta de legibilidade e segurança de tipos para o fluxo de dados, mas o seu uso possui restrições severas.

* **ONDE USAR:** **Apenas na fronteira do Repositório para cima (Domain e Presentation).** Ele é o contrato que o domínio assina com a tela dizendo: *"Eu garanto entregar de forma explícita uma falha tipada ou o dado de sucesso"*.
* **ONDE NÃO USAR:** **Nas camadas de Data (Services e DataSources).** Serviços e fontes de dados devem falar a linguagem idiomática e nativa do Dart/Flutter. Usar `Either` na infraestrutura gera aninhamento desnecessário de código (`switch/fold`) e infla a manutenção.

---

## 🔄 3. O Fluxo de Transformação Unificado

O ciclo de vida de uma operação assíncrona segue este fluxo padrão ouro:

```text
 [ Camada: DATA ]                          [ Camada: DOMAIN ]            [ Camada: PRESENTATION ]
 ┌──────────────┐      ┌──────────────┐     ┌─────────────────┐           ┌──────────────────────┐
 │ Api/Local    │      │ Feature      │     │ Feature         │           │ Controller /         │
 │ Service      │      │ DataSource   │     │ RepositoryImpl  │           │ Notifier / State     │
 └──────┬───────┘      └──────┬───────┘     └────────┬────────┘           └──────────┬───────────┘
        │                     │                      │                               │
        │  throw Exception    │                      │                               │
        ├────────────────────>│                      │                               │
        │                     │   throw Exception    │                               │
        │                     ├─────────────────────>│                               │
        │                     │                      │   return Left(Failure)        │
        │                     │                      ├──────────────────────────────>│ (Lê via pattern
        │                     │                      │   ou Right(Success)           │  matching / fold)