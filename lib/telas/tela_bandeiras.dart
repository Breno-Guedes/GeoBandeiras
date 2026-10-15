import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../utilitarios/texto_util.dart';

/// Lista de estudo com todas as bandeiras e nomes (com busca).
class TelaBandeiras extends StatefulWidget {
  const TelaBandeiras({super.key});

  @override
  State<TelaBandeiras> createState() => _TelaBandeirasState();
}

class _TelaBandeirasState extends State<TelaBandeiras> {
  String _busca = '';

  @override
  Widget build(BuildContext context) {
    final estado = EscopoEstado.de(context);
    final textos = estado.textos;
    final idioma = estado.idioma;

    final termo = semAcentos(_busca.trim());
    final lista = estado.paises
        .where((p) => semAcentos(p.nome(idioma)).contains(termo))
        .toList()
      ..sort((a, b) =>
          semAcentos(a.nome(idioma)).compareTo(semAcentos(b.nome(idioma))));

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(title: Text(textos.t('bandeiras_titulo'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: textos.t('bandeiras_buscar'),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (valor) => setState(() => _busca = valor),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? Center(child: Text(textos.t('bandeiras_nenhuma')))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: lista.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, indice) {
                      final pais = lista[indice];
                      return ListTile(
                        leading: SizedBox(
                          width: 56,
                          child: Image.asset(pais.bandeira64,
                              fit: BoxFit.contain),
                        ),
                        title: Text(
                          pais.nome(idioma),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(textos.continente(pais.continente)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
