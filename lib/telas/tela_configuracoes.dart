import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../localizacao/textos.dart';
import '../modelos/pais.dart';

/// Tempo de jogo, dificuldade e idioma. Tudo fica salvo no aparelho.
class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = EscopoEstado.de(context);
    final textos = estado.textos;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(title: Text(textos.t('config_titulo'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Secao(
                titulo: textos.t('config_tempo'),
                subtitulo: textos.t('config_tempo_desc'),
                icone: Icons.timer,
                filhos: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      for (final segundos in EstadoApp.temposDisponiveis)
                        ChoiceChip(
                          label: Text(textos.tempo(segundos)),
                          selected: estado.tempoSegundos == segundos,
                          onSelected: (_) => estado.definirTempo(segundos),
                        ),
                    ],
                  ),
                ],
              ),
              _Secao(
                titulo: textos.t('config_volume'),
                subtitulo: textos.t('config_volume_desc'),
                icone: estado.volumeMusica == 0
                    ? Icons.volume_off
                    : Icons.volume_up,
                filhos: [
                  Row(
                    children: [
                      const Icon(Icons.volume_down, color: Colors.black54),
                      Expanded(
                        child: Slider(
                          value: estado.volumeMusica,
                          divisions: 10,
                          label: '${(estado.volumeMusica * 100).round()}%',
                          onChanged: estado.definirVolumeMusica,
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.black54),
                    ],
                  ),
                ],
              ),
              _Secao(
                titulo: textos.t('config_dificuldade'),
                icone: Icons.speed,
                filhos: [
                  for (final dificuldade in Dificuldade.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(textos.dificuldade(dificuldade)),
                            selected: estado.dificuldade == dificuldade,
                            onSelected: (_) =>
                                estado.definirDificuldade(dificuldade),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              textos.t('dif_${dificuldade.name}_desc'),
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              _Secao(
                titulo: textos.t('config_idioma'),
                icone: Icons.language,
                filhos: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      for (final idioma in Textos.idiomasDisponiveis)
                        ChoiceChip(
                          label: Text(Textos.nomesIdiomas[idioma]!),
                          selected: estado.idioma == idioma,
                          onSelected: (_) => estado.definirIdioma(idioma),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final IconData icone;
  final List<Widget> filhos;

  const _Secao({
    required this.titulo,
    required this.icone,
    required this.filhos,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: const Color(0xFF1565C0)),
                const SizedBox(width: 8),
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            if (subtitulo != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(subtitulo!,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ),
            const SizedBox(height: 12),
            ...filhos,
          ],
        ),
      ),
    );
  }
}
