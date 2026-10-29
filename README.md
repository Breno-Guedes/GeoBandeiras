# Geo Bandeiras

**Geo Bandeiras** é um jogo de perguntas e respostas desenvolvido em Flutter e Dart, no qual o jogador deve identificar países por meio de suas bandeiras. O projeto foi desenvolvido como atividade acadêmica da disciplina de Programação para Dispositivos Móveis (PDM).

**Autor:** Breno de Souza Guedes

## Funcionalidades

- **Quiz de bandeiras:** identifica países a partir de suas bandeiras.
- **Modo aleatório:** apresenta países selecionados aleatoriamente.
- **Modo por continente:** permite jogar com países de uma região específica.
- **Alternativas de resposta:** apresenta quatro opções para cada pergunta.
- **Pontuação:** acompanha o desempenho do jogador durante a partida.
- **Cronômetro:** adiciona um desafio de tempo.
- **Dificuldade:** oferece os níveis Fácil e Difícil.
- **Feedback visual:** informa se a resposta está correta ou incorreta.
- **Animações:** tornam as interações mais dinâmicas.
- **Configurações de áudio:** permite ajustar o volume da música de fundo.
- **Multilíngue:** oferece suporte a português, inglês e espanhol.

## Tecnologias utilizadas

- Flutter
- Dart
- Material Design
- Android SDK
- Git e GitHub
- Visual Studio Code

## Pré-requisitos

Antes de executar o projeto, instale e configure:

- Flutter SDK.
- Android Studio e Android SDK.
- Git.
- Emulador Android ou dispositivo físico.

Verifique a instalação com:

```bash
flutter --version
flutter doctor
git --version
```

## Instalação

**1. Clone o repositório:**

```bash
git clone https://github.com/Breno-Guedes/GeoBandeiras.git
```

**2. Acesse o diretório do projeto:**

```bash
cd GeoBandeiras
```

**3. Instale as dependências:**

```bash
flutter pub get
```

**4. Verifique os dispositivos disponíveis:**

```bash
flutter devices
```

## Como executar

Com um emulador aberto ou um dispositivo conectado, execute:

```bash
flutter run
```

Para executar em um dispositivo específico:

```bash
flutter run -d ID_DO_DISPOSITIVO
```

## Como jogar

1. Abra o aplicativo.
2. Escolha o modo de jogo: aleatório ou por continente.
3. Selecione a dificuldade desejada.
4. Observe a bandeira apresentada.
5. Escolha uma das quatro alternativas.
6. Confira o feedback e acompanhe sua pontuação.
7. Continue até o encerramento da partida.

## Regras e mecânica do jogo

O jogador deve selecionar o país correspondente à bandeira exibida. O sistema verifica a resposta, apresenta um feedback visual e atualiza a pontuação conforme as regras da partida.

No modo aleatório, os países são selecionados de diferentes regiões. No modo por continente, as perguntas são limitadas à região escolhida. O cronômetro e os níveis de dificuldade complementam o desafio.

## Estrutura do projeto

O código-fonte está organizado em diretórios que separam as responsabilidades da aplicação, facilitando a manutenção e a evolução do projeto.

```text
lib/
├── estado/
├── localizacao/
├── modelos/
├── servicos/
├── telas/
├── utilitarios/
├── widgets/
└── main.dart
```

- **estado/**: gerenciamento do estado da aplicação e da partida.
- **localizacao/**: recursos relacionados aos idiomas disponíveis.
- **modelos/**: classes e estruturas de dados, como os países.
- **servicos/**: funcionalidades e operações utilizadas pelo jogo.
- **telas/**: telas e páginas da interface.
- **utilitarios/**: funções auxiliares e ferramentas reutilizáveis.
- **widgets/**: componentes visuais reutilizáveis.
- **main.dart**: ponto de entrada da aplicação.

## Análise e testes

Para analisar o código:

```bash
flutter analyze
```

Para formatar os arquivos Dart:

```bash
dart format lib
```

Para executar os testes automatizados:

```bash
flutter test
```

## Compilação para Android

Para gerar um APK de lançamento:

```bash
flutter build apk --release
```

O arquivo normalmente será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Para gerar um Android App Bundle:

```bash
flutter build appbundle --release
```

## Conceitos aplicados

O projeto trabalha conceitos de orientação a objetos, funções, listas, seleção aleatória, filtragem de dados, validação de respostas, gerenciamento de estado, navegação entre telas e construção de interfaces com Flutter.

## Melhorias futuras

Entre as possíveis melhorias estão o histórico de partidas, recordes, estatísticas de desempenho, conquistas, novos modos de jogo e testes automatizados adicionais.

## Autor

**Breno de Souza Guedes**

Estudante de Análise e Desenvolvimento de Sistemas (ADS) do Instituto Federal do Piauí (IFPI), Campus Corrente.

**Vídeo de apresentação:** [Assistir no YouTube](https://youtu.be/JNoLl0e1Yzk?si=GRzQFO0fvzf7IUVv)

