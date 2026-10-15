import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../localizacao/textos.dart';
import '../modelos/entrada_ranking.dart';
import '../servicos/armazenamento_ranking.dart';
import '../utilitarios/texto_util.dart';

/// Melhores pontuações salvas no aparelho.
class TelaRanking extends StatefulWidget {
  const TelaRanking({super.key});

  @override
  State<TelaRanking> createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking> {
  List<EntradaRanking>? _entradas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final entradas = await ArmazenamentoRanking.carregar();
    if (!mounted) return;
    setState(() => _entradas = entradas);
  }

  Future<void> _limparRanking() async {
    final textos = EscopoEstado.de(context).textos;
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: Text(textos.t('rank_limpar')),
        content: Text(textos.t('rank_limpar_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: Text(textos.t('cancelar')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: Text(textos.t('apagar')),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      await ArmazenamentoRanking.limpar();
      await _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = EscopoEstado.de(context).textos;
    final entradas = _entradas;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(
        title: Text(textos.t('rank_titulo')),
        actions: [
          if (entradas != null && entradas.isNotEmpty)
            IconButton(
              tooltip: textos.t('rank_limpar'),
              icon: const Icon(Icons.delete_outline),
              onPressed: _limparRanking,
            ),
        ],
      ),
      body: entradas == null
          ? const Center(child: CircularProgressIndicator())
          : entradas.isEmpty
              ? Center(
                  child: Text(
                    textos.t('rank_vazio'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: entradas.length,
                  itemBuilder: (context, indice) =>
                      _linha(textos, entradas[indice], indice),
                ),
    );
  }

  Widget _linha(Textos textos, EntradaRanking entrada, int indice) {
    const medalhas = [Color(0xFFFFC107), Color(0xFF9E9E9E), Color(0xFFA1887F)];
    final corPosicao = indice < 3 ? medalhas[indice] : const Color(0xFF90A4AE);

    final modo = entrada.continente == null
        ? textos.t('mundo_todo')
        : textos.t('continente_${entrada.continente}');
    final dificuldade = textos.t('dif_${entrada.dificuldade}');
    final detalhes = '$modo • ${textos.tempo(entrada.duracaoSegundos)} • '
        '$dificuldade\n${entrada.acertos}/${entrada.total} '
        '(${entrada.percentual.toStringAsFixed(0)}%) • ${formatarData(entrada.data)}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: corPosicao,
          child: Text('${indice + 1}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Text(
          entrada.nome.isEmpty ? textos.t('nome_padrao') : entrada.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(detalhes),
        isThreeLine: true,
        trailing: Text(
          '${entrada.pontos}',
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1565C0)),
        ),
      ),
    );
  }
}
