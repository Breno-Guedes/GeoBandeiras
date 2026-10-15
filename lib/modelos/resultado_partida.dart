import 'configuracao_partida.dart';

class ResultadoPartida {
  static const int pontosPorAcerto = 10;

  final ConfiguracaoPartida configuracao;
  final int totalRespondidas;
  final int acertos;

  const ResultadoPartida({
    required this.configuracao,
    required this.totalRespondidas,
    required this.acertos,
  });

  int get erros => totalRespondidas - acertos;
  int get pontos => acertos * pontosPorAcerto;

  /// Percentual de acertos (0 a 100).
  double get percentual =>
      totalRespondidas == 0 ? 0 : acertos * 100 / totalRespondidas;
}
