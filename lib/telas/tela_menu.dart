import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../localizacao/textos.dart';
import '../modelos/configuracao_partida.dart';
import '../widgets/botao_menu.dart';
import 'tela_bandeiras.dart';
import 'tela_configuracoes.dart';
import 'tela_continentes.dart';
import 'tela_jogo.dart';
import 'tela_ranking.dart';
import 'tela_sobremim.dart';

/// Tela inicial (menu principal).
class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = EscopoEstado.de(context);
    final textos = estado.textos;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Image.asset('assets/home.png', height: 150),
                const SizedBox(height: 4),
                Text(
                  textos.t('app_titulo'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1565C0),
                  ),
                ),
                Text(
                  textos.t('app_subtitulo'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                // Resumo das configurações atuais.
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.timer, size: 18),
                      label: Text(textos.tempo(estado.tempoSegundos)),
                    ),
                    Chip(
                      avatar: const Icon(Icons.speed, size: 18),
                      label: Text(textos.dificuldade(estado.dificuldade)),
                    ),
                    Chip(
                      avatar: const Icon(Icons.language, size: 18),
                      label: Text(Textos.nomesIdiomas[estado.idioma] ?? ''),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BotaoMenu(
                  icone: Icons.public,
                  cor: const Color(0xFF1E88E5),
                  titulo: textos.t('menu_continente'),
                  descricao: textos.t('menu_continente_desc'),
                  aoTocar: () => _abrir(context, const TelaContinentes()),
                ),
                BotaoMenu(
                  icone: Icons.shuffle,
                  cor: const Color(0xFF43A047),
                  titulo: textos.t('menu_aleatorio'),
                  descricao: textos.t('menu_aleatorio_desc'),
                  aoTocar: () => _abrir(
                    context,
                    TelaJogo(
                      configuracao: ConfiguracaoPartida(
                        duracaoSegundos: estado.tempoSegundos,
                        dificuldade: estado.dificuldade,
                      ),
                    ),
                  ),
                ),
                BotaoMenu(
                  icone: Icons.timer,
                  cor: const Color(0xFFFB8C00),
                  titulo: textos.t('menu_config'),
                  descricao: textos.t('menu_config_desc'),
                  aoTocar: () => _abrir(context, const TelaConfiguracoes()),
                ),
                BotaoMenu(
                  icone: Icons.emoji_events,
                  cor: const Color(0xFFF9A825),
                  titulo: textos.t('menu_ranking'),
                  descricao: textos.t('menu_ranking_desc'),
                  aoTocar: () => _abrir(context, const TelaRanking()),
                ),
                BotaoMenu(
                  icone: Icons.flag,
                  cor: const Color(0xFF8E24AA),
                  titulo: textos.t('menu_bandeiras'),
                  descricao: textos.t('menu_bandeiras_desc'),
                  aoTocar: () => _abrir(context, const TelaBandeiras()),
                ),
                BotaoMenu(
                  icone: Icons.person,
                  cor: const Color(0xFF00897B),
                  titulo: textos.t('menu_sobremim'),
                  descricao: textos.t('menu_sobremim_desc'),
                  aoTocar: () => _abrir(context, const SobreMim()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }
}
