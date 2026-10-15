import 'pais.dart';

class Pergunta {
  final Pais correto;
  final List<Pais> opcoes; // 4 opções, já embaralhadas

  const Pergunta({required this.correto, required this.opcoes});
}
