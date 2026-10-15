import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/entrada_ranking.dart';

/// Salva e lê as maiores pontuações usando `shared_preferences`.
class ArmazenamentoRanking {
  static const String _chave = 'ranking_pontuacoes';
  static const int limite = 20;

  static Future<List<EntradaRanking>> carregar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final texto = prefs.getString(_chave);
      if (texto == null) return [];
      final lista = jsonDecode(texto) as List<dynamic>;
      final entradas = lista
          .map((e) => EntradaRanking.deJson(e as Map<String, dynamic>))
          .toList();
      _ordenar(entradas);
      return entradas;
    } catch (_) {
      return [];
    }
  }

  static Future<void> salvar(EntradaRanking entrada) async {
    final entradas = await carregar();
    entradas.add(entrada);
    _ordenar(entradas);
    final mantidas = entradas.take(limite).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _chave, jsonEncode(mantidas.map((e) => e.paraJson()).toList()));
  }

  static Future<void> limpar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chave);
  }

  static void _ordenar(List<EntradaRanking> entradas) {
    entradas.sort((a, b) {
      final porPontos = b.pontos.compareTo(a.pontos);
      if (porPontos != 0) return porPontos;
      return b.percentual.compareTo(a.percentual);
    });
  }
}
