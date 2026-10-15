import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_flags_quiz/modelos/configuracao_partida.dart';
import 'package:flutter_flags_quiz/modelos/pais.dart';
import 'package:flutter_flags_quiz/modelos/resultado_partida.dart';
import 'package:flutter_flags_quiz/servicos/gerador_perguntas.dart';
import 'package:flutter_flags_quiz/servicos/repositorio_paises.dart';
import 'package:flutter_test/flutter_test.dart';

List<Pais> carregarPaises() {
  final texto = File('assets/dados/paises.json').readAsStringSync();
  return RepositorioPaises.interpretar(texto);
}

void main() {
  final paises = carregarPaises();

  test('banco tem 193 países com nomes nos 3 idiomas', () {
    expect(paises.length, 193);
    for (final p in paises) {
      expect(p.nomes['pt'], isNotEmpty);
      expect(p.nomes['en'], isNotEmpty);
      expect(p.nomes['es'], isNotEmpty);
    }
  });

  test('todo país tem arquivo de bandeira', () {
    for (final p in paises) {
      expect(File(p.bandeira128).existsSync(), isTrue, reason: p.codigo);
      expect(File(p.bandeira64).existsSync(), isTrue, reason: p.codigo);
    }
  });

  test('modo por continente só sorteia o continente escolhido', () {
    for (final continente in Continente.values) {
      final gerador = GeradorPerguntas(
        todosPaises: paises,
        configuracao: ConfiguracaoPartida(
          continente: continente,
          duracaoSegundos: 60,
          dificuldade: Dificuldade.dificil,
        ),
        aleatorio: Random(1),
      );
      for (var i = 0; i < 40; i++) {
        final pergunta = gerador.proxima();
        expect(pergunta.opcoes.length, 4);
        expect(pergunta.opcoes.every((p) => p.continente == continente), isTrue);
        expect(pergunta.opcoes.contains(pergunta.correto), isTrue);
        final codigos = pergunta.opcoes.map((p) => p.codigo).toSet();
        expect(codigos.length, 4, reason: 'opções repetidas');
      }
    }
  });

  test('modo fácil usa só países fáceis', () {
    final gerador = GeradorPerguntas(
      todosPaises: paises,
      configuracao: const ConfiguracaoPartida(
        duracaoSegundos: 30,
        dificuldade: Dificuldade.facil,
      ),
    );
    for (var i = 0; i < 50; i++) {
      final pergunta = gerador.proxima();
      expect(
        pergunta.opcoes.every((p) => p.dificuldade == Dificuldade.facil),
        isTrue,
      );
    }
  });

  test('nenhuma bandeira repete antes de esgotar o banco', () {
    final gerador = GeradorPerguntas(
      todosPaises: paises,
      configuracao: const ConfiguracaoPartida(
        duracaoSegundos: 300,
        dificuldade: Dificuldade.dificil,
      ),
    );
    final vistos = <String>{};
    for (var i = 0; i < gerador.tamanhoBanco; i++) {
      expect(vistos.add(gerador.proxima().correto.codigo), isTrue);
    }
  });

  test('resultado calcula pontos e percentual', () {
    const resultado = ResultadoPartida(
      configuracao: ConfiguracaoPartida(
        duracaoSegundos: 60,
        dificuldade: Dificuldade.facil,
      ),
      totalRespondidas: 8,
      acertos: 6,
    );
    expect(resultado.pontos, 60);
    expect(resultado.erros, 2);
    expect(resultado.percentual, 75);
  });

  test('json é válido UTF-8', () {
    final texto = File('assets/dados/paises.json').readAsStringSync();
    expect(jsonDecode(texto), isA<List>());
  });
}
