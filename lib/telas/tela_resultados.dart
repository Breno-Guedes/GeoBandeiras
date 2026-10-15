import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../localizacao/textos.dart';
import '../modelos/entrada_ranking.dart';
import '../modelos/resultado_partida.dart';
import '../servicos/armazenamento_ranking.dart';
import 'tela_jogo.dart';

/// Resumo da partida: perguntas, acertos, percentual e pontuação final.
class TelaResultados extends StatefulWidget {
  final ResultadoPartida resultado;

  const TelaResultados({super.key, required this.resultado});

  @override
  State<TelaResultados> createState() => _TelaResultadosState();
}

class _TelaResultadosState extends State<TelaResultados> {
  final TextEditingController _controladorNome = TextEditingController();
  bool _salvo = false;
  bool _recorde = false;
  bool _nomeInicializado = false;

  @override
  void initState() {
    super.initState();
    _verificarRecorde();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_nomeInicializado) {
      _nomeInicializado = true;
      _controladorNome.text = EscopoEstado.de(context).nomeJogador;
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    super.dispose();
  }

  Future<void> _verificarRecorde() async {
    final entradas = await ArmazenamentoRanking.carregar();
    if (!mounted) return;
    final pontos = widget.resultado.pontos;
    final melhor = entradas.isEmpty ? 0 : entradas.first.pontos;
    setState(() => _recorde = pontos > 0 && pontos > melhor);
  }

  Future<void> _salvarNoRanking() async {
    final estado = EscopoEstado.de(context);
    final resultado = widget.resultado;
    final nome = _controladorNome.text.trim().isEmpty
        ? estado.textos.t('nome_padrao')
        : _controladorNome.text.trim();

    await estado.definirNomeJogador(nome);
    await ArmazenamentoRanking.salvar(
      EntradaRanking(
        nome: nome,
        pontos: resultado.pontos,
        acertos: resultado.acertos,
        total: resultado.totalRespondidas,
        continente: resultado.configuracao.continente?.name,
        duracaoSegundos: resultado.configuracao.duracaoSegundos,
        dificuldade: resultado.configuracao.dificuldade.name,
        data: DateTime.now(),
      ),
    );
    if (!mounted) return;
    setState(() => _salvo = true);
  }

  void _jogarNovamente() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TelaJogo(configuracao: widget.resultado.configuracao),
      ),
    );
  }

  void _voltarAoMenu() {
    Navigator.popUntil(context, (rota) => rota.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final textos = EscopoEstado.de(context).textos;
    final resultado = widget.resultado;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(textos.t('res_titulo')),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events,
                            size: 64, color: Color(0xFFF9A825)),
                        if (_recorde)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              textos.t('res_recorde'),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32)),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(textos.t('res_pontuacao'),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54)),
                        Text(
                          '${resultado.pontos}',
                          style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1565C0)),
                        ),
                        const Divider(height: 28),
                        _linha(textos.t('res_perguntas'),
                            '${resultado.totalRespondidas}'),
                        _linha(textos.t('res_acertos'), '${resultado.acertos}',
                            cor: const Color(0xFF2E7D32)),
                        _linha(textos.t('res_erros'), '${resultado.erros}',
                            cor: const Color(0xFFC62828)),
                        _linha(textos.t('res_percentual'),
                            '${resultado.percentual.toStringAsFixed(1)}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (resultado.pontos > 0) _construirSalvar(textos),
                const SizedBox(height: 8),
                BotaoColorido(
                  icone: Icons.replay,
                  texto: textos.t('res_jogar_novamente'),
                  cor: const Color(0xFF43A047),
                  aoTocar: _jogarNovamente,
                ),
                const SizedBox(height: 10),
                BotaoColorido(
                  icone: Icons.home,
                  texto: textos.t('res_voltar_menu'),
                  cor: const Color(0xFF1E88E5),
                  aoTocar: _voltarAoMenu,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirSalvar(Textos textos) {
    if (_salvo) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(textos.t('res_salvo'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        TextField(
          controller: _controladorNome,
          maxLength: 16,
          decoration: InputDecoration(
            labelText: textos.t('config_nome'),
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        BotaoColorido(
          icone: Icons.leaderboard,
          texto: textos.t('res_salvar'),
          cor: const Color(0xFFF9A825),
          aoTocar: _salvarNoRanking,
        ),
      ],
    );
  }

  Widget _linha(String rotulo, String valor, {Color cor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(rotulo, style: const TextStyle(fontSize: 16)),
          ),
          Text(valor,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: cor)),
        ],
      ),
    );
  }
}

/// Botão simples e colorido (independe de versões do ElevatedButton/FilledButton).
class BotaoColorido extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color cor;
  final VoidCallback aoTocar;

  const BotaoColorido({
    super.key,
    required this.icone,
    required this.texto,
    required this.cor,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: Colors.white),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  texto,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
