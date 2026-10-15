import 'pais.dart';

/// Parâmetros escolhidos antes de iniciar uma partida.
class ConfiguracaoPartida {
  /// `null` significa "Jogo Aleatório" (todos os continentes).
  final Continente? continente;
  final int duracaoSegundos;
  final Dificuldade dificuldade;

  const ConfiguracaoPartida({
    this.continente,
    required this.duracaoSegundos,
    required this.dificuldade,
  });

  bool get aleatorio => continente == null;
}
