/// Uma linha do ranking salvo localmente.
class EntradaRanking {
  final String nome;
  final int pontos;
  final int acertos;
  final int total;
  final String? continente; // nome do enum Continente; null = aleatório
  final int duracaoSegundos;
  final String dificuldade; // nome do enum Dificuldade
  final DateTime data;

  const EntradaRanking({
    required this.nome,
    required this.pontos,
    required this.acertos,
    required this.total,
    required this.continente,
    required this.duracaoSegundos,
    required this.dificuldade,
    required this.data,
  });

  double get percentual => total == 0 ? 0 : acertos * 100 / total;

  Map<String, dynamic> paraJson() => {
        'nome': nome,
        'pontos': pontos,
        'acertos': acertos,
        'total': total,
        'continente': continente,
        'duracao': duracaoSegundos,
        'dificuldade': dificuldade,
        'data': data.toIso8601String(),
      };

  factory EntradaRanking.deJson(Map<String, dynamic> json) {
    return EntradaRanking(
      nome: json['nome'] as String,
      pontos: json['pontos'] as int,
      acertos: json['acertos'] as int,
      total: json['total'] as int,
      continente: json['continente'] as String?,
      duracaoSegundos: json['duracao'] as int,
      dificuldade: json['dificuldade'] as String,
      data: DateTime.parse(json['data'] as String),
    );
  }
}
