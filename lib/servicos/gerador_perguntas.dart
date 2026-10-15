import 'dart:math';

import '../modelos/configuracao_partida.dart';
import '../modelos/pais.dart';
import '../modelos/pergunta.dart';

/// Sorteia as perguntas de uma partida.
///
/// As bandeiras são tiradas de uma fila embaralhada, então nenhuma se repete
/// até que todas as bandeiras disponíveis tenham aparecido.
class GeradorPerguntas {
  static const int quantidadeOpcoes = 4;

  final List<Pais> _banco;
  final Random _aleatorio;
  final List<Pais> _fila = [];

  GeradorPerguntas({
    required List<Pais> todosPaises,
    required ConfiguracaoPartida configuracao,
    Random? aleatorio,
  })  : _banco = filtrarBanco(todosPaises, configuracao),
        _aleatorio = aleatorio ?? Random();

  /// Quantidade de países que podem aparecer na partida.
  int get tamanhoBanco => _banco.length;

  /// Aplica o filtro de continente e de dificuldade.
  static List<Pais> filtrarBanco(
      List<Pais> todos, ConfiguracaoPartida configuracao) {
    final continente = configuracao.continente;
    final base = continente == null
        ? List<Pais>.from(todos)
        : todos.where((p) => p.continente == continente).toList();

    if (configuracao.dificuldade == Dificuldade.facil) {
      final conhecidos =
          base.where((p) => p.dificuldade == Dificuldade.facil).toList();
      // Só usa o filtro se sobrarem países suficientes para montar 4 opções.
      if (conhecidos.length >= quantidadeOpcoes) return conhecidos;
    }
    return base;
  }

  Pergunta proxima() {
    if (_fila.isEmpty) {
      _fila.addAll(_banco);
      _fila.shuffle(_aleatorio);
    }
    final correto = _fila.removeLast();

    final candidatos = _banco.where((p) => p.codigo != correto.codigo).toList()
      ..shuffle(_aleatorio);
    final opcoes = <Pais>[
      correto,
      ...candidatos.take(quantidadeOpcoes - 1),
    ]..shuffle(_aleatorio);

    return Pergunta(correto: correto, opcoes: opcoes);
  }
}
