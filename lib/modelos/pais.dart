/// Continentes disponíveis no modo "Jogar por Continente".
enum Continente { africa, america, asia, europa, oceania }

/// Nível de dificuldade: no modo fácil só aparecem países mais conhecidos.
enum Dificuldade { facil, dificil }

class Pais {
  final String codigo; // código ISO alpha-2 (também é o nome do arquivo PNG)
  final Continente continente;
  final Dificuldade dificuldade;
  final Map<String, String> nomes; // idioma -> nome

  const Pais({
    required this.codigo,
    required this.continente,
    required this.dificuldade,
    required this.nomes,
  });

  factory Pais.deJson(Map<String, dynamic> json) {
    return Pais(
      codigo: json['codigo'] as String,
      continente: Continente.values
          .firstWhere((c) => c.name == (json['continente'] as String)),
      dificuldade: Dificuldade.values
          .firstWhere((d) => d.name == (json['dificuldade'] as String)),
      nomes: Map<String, String>.from(json['nomes'] as Map),
    );
  }

  /// Nome do país no idioma pedido (usa português se não existir tradução).
  String nome(String idioma) => nomes[idioma] ?? nomes['pt'] ?? codigo;

  String get bandeira64 => 'assets/flags/64x64/$codigo.png';
  String get bandeira128 => 'assets/flags/128x128/$codigo.png';

  @override
  String toString() => 'Pais($codigo, ${nomes['pt']})';
}
