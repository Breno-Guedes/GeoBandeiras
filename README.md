# GeoBandeiras

Quiz de bandeiras feito em Flutter. Adivinhe o país de cada bandeira antes que o tempo acabe!

## Funcionalidades

**Obrigatórias**
- Menu principal: *Jogar por Continente* (África, América, Ásia, Europa, Oceania), *Jogo Aleatório* e *Configuração do Tempo* (30 s, 60 s, 3 min, 5 min).
- Tela de jogo: bandeira no topo, 4 opções, cronômetro regressivo e pontuação. Após responder mostra se acertou ou errou e passa sozinho para a próxima.
- Tela de resultados: perguntas respondidas, acertos, erros, percentual (%) e botão para voltar ao menu.
- Banco de dados de bandeiras em JSON, organizado por continente (`assets/dados/paises.json`), com os nomes dos países **em português**.

**Extras**
- Dificuldade **Fácil** (países mais conhecidos) e **Difícil** (todos, inclusive os menos conhecidos).
- **Ranking** local com `shared_preferences` (top 20, com nome, modo, tempo e dificuldade).
- **Idiomas**: português, inglês e espanhol (interface *e* nomes dos países).
- **Animações**: a bandeira pulsa ao acertar e treme ao errar; o resultado aparece com um selo animado e os botões mudam de cor.
- Tela *Ver Bandeiras* para estudar (com busca sem diferenciar acentos).

## Como rodar

```bash
flutter pub get
flutter run
flutter test        # testes do gerador de perguntas, ranking e menu
```

## Estrutura do código

```
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

## Regras do jogo

- 10 pontos por resposta correta.
- O tempo configurado é o tempo **total** da partida; ele fica parado durante a exibição do resultado de cada resposta (~1,2 s).
- As bandeiras não se repetem até que todas as disponíveis tenham aparecido.
- Continentes: Américas do Norte, Central e do Sul formam "América". Turquia, Geórgia, Armênia, Azerbaijão e Cazaquistão estão na Ásia; Rússia e Chipre na Europa. Para mudar, edite `tools/gerar_paises.py` e rode-o de novo (ou edite o JSON direto).

## Créditos

- Bandeiras e códigos ISO: [world_countries](https://github.com/stefangabos/world_countries) (projeto base `flutter_flags_quiz`).
