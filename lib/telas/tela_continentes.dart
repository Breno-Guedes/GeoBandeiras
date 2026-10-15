import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/configuracao_partida.dart';
import '../modelos/pais.dart';
import '../widgets/botao_menu.dart';
import 'tela_jogo.dart';

/// O jogador escolhe o continente e a partida começa.
class TelaContinentes extends StatelessWidget {
  const TelaContinentes({super.key});

  static const Map<Continente, Color> _cores = {
    Continente.africa: Color(0xFFEF6C00),
    Continente.america: Color(0xFF2E7D32),
    Continente.asia: Color(0xFFC62828),
    Continente.europa: Color(0xFF1565C0),
    Continente.oceania: Color(0xFF00838F),
  };

  @override
  Widget build(BuildContext context) {
    final estado = EscopoEstado.de(context);
    final textos = estado.textos;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(title: Text(textos.t('escolha_continente'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final continente in Continente.values)
                BotaoMenu(
                  icone: Icons.public,
                  cor: _cores[continente]!,
                  titulo: textos.continente(continente),
                  descricao: textos.t('paises_qtd', {
                    'n': estado.paises
                        .where((p) => p.continente == continente)
                        .length,
                  }),
                  aoTocar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaJogo(
                          configuracao: ConfiguracaoPartida(
                            continente: continente,
                            duracaoSegundos: estado.tempoSegundos,
                            dificuldade: estado.dificuldade,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
