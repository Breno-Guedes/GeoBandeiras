import 'dart:convert';

import 'package:flutter/services.dart';

import '../modelos/pais.dart';

/// Lê o banco de dados de bandeiras (assets/dados/paises.json).
class RepositorioPaises {
  static const String caminho = 'assets/dados/paises.json';

  static Future<List<Pais>> carregar() async {
    final texto = await rootBundle.loadString(caminho);
    return interpretar(texto);
  }

  static List<Pais> interpretar(String texto) {
    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map<Pais>((item) => Pais.deJson(item as Map<String, dynamic>))
        .toList();
  }
}
