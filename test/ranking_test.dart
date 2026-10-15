import 'package:flutter_flags_quiz/modelos/entrada_ranking.dart';
import 'package:flutter_flags_quiz/servicos/armazenamento_ranking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

EntradaRanking entrada(String nome, int pontos) => EntradaRanking(
      nome: nome,
      pontos: pontos,
      acertos: pontos ~/ 10,
      total: 10,
      continente: null,
      duracaoSegundos: 60,
      dificuldade: 'facil',
      data: DateTime(2024, 1, 1),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('ranking fica ordenado por pontos e pode ser limpo', () async {
    await ArmazenamentoRanking.salvar(entrada('Ana', 30));
    await ArmazenamentoRanking.salvar(entrada('Bia', 90));
    await ArmazenamentoRanking.salvar(entrada('Caio', 50));

    final lista = await ArmazenamentoRanking.carregar();
    expect(lista.map((e) => e.nome).toList(), ['Bia', 'Caio', 'Ana']);

    await ArmazenamentoRanking.limpar();
    expect(await ArmazenamentoRanking.carregar(), isEmpty);
  });

  test('ranking guarda no máximo 20 entradas', () async {
    for (var i = 0; i < 25; i++) {
      await ArmazenamentoRanking.salvar(entrada('J$i', i * 10));
    }
    final lista = await ArmazenamentoRanking.carregar();
    expect(lista.length, ArmazenamentoRanking.limite);
    expect(lista.first.pontos, 240);
  });
}
