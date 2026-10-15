/// Remove acentos para ordenar e buscar nomes (ex.: "África" vem antes de "Alemanha").
String semAcentos(String texto) {
  const origem = 'áàâãäåçéèêëíìîïñóòôõöúùûüýÿ';
  const destino = 'aaaaaaceeeeiiiinooooouuuuyy';
  final buffer = StringBuffer();
  for (final codigo in texto.toLowerCase().runes) {
    final letra = String.fromCharCode(codigo);
    final posicao = origem.indexOf(letra);
    buffer.write(posicao >= 0 ? destino[posicao] : letra);
  }
  return buffer.toString();
}

/// Formata a data como dd/mm/aaaa.
String formatarData(DateTime data) {
  String dois(int n) => n.toString().padLeft(2, '0');
  return '${dois(data.day)}/${dois(data.month)}/${data.year}';
}
