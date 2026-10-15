import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../localizacao/textos.dart';
import '../modelos/configuracao_partida.dart';
import '../modelos/pais.dart';
import '../modelos/pergunta.dart';
import '../modelos/resultado_partida.dart';
import '../servicos/gerador_perguntas.dart';
import '../widgets/botao_resposta.dart';
import 'tela_resultados.dart';
import '../servicos/audio.dart';

/// Tela da partida: bandeira no topo, 4 opções e cronômetro regressivo.
class TelaJogo extends StatefulWidget {
  final ConfiguracaoPartida configuracao;

  const TelaJogo({super.key, required this.configuracao});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo>
    with SingleTickerProviderStateMixin {
  static const Duration _tempoFeedback = Duration(milliseconds: 1200);
  static const int _intervaloMs = 100;

  final AudioService _audioService = AudioService();

  GeradorPerguntas? _gerador;
  late Pergunta _pergunta;
  late int _restanteMs;
  late DateTime _ultimoTick;
  late AnimationController _animacao;

  Timer? _cronometro;
  Timer? _temporizadorProxima;
  Timer? _temporizadorFim;

  int _acertos = 0;
  int _respondidas = 0;
  String? _escolhido; // código do país escolhido; null = aguardando resposta
  bool _finalizado = false;

  bool get _acertou => _escolhido == _pergunta.correto.codigo;

  @override
  void initState() {
    super.initState();
    _animacao = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _restanteMs = widget.configuracao.duracaoSegundos * 1000;
    _ultimoTick = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // O gerador precisa do banco de países, que vem do estado global.
    if (_gerador == null) {
      final estado = EscopoEstado.de(context);
      _gerador = GeradorPerguntas(
        todosPaises: estado.paises,
        configuracao: widget.configuracao,
      );
      _pergunta = _gerador!.proxima();
      _ultimoTick = DateTime.now();
      _cronometro = Timer.periodic(
        const Duration(milliseconds: _intervaloMs),
        (_) => _atualizarCronometro(),
      );
    }
  }

  @override
  void dispose() {
    _cronometro?.cancel();
    _temporizadorProxima?.cancel();
    _temporizadorFim?.cancel();
    _animacao.dispose();
    super.dispose();
  }

  void _atualizarCronometro() {
    final agora = DateTime.now();
    final decorrido = agora.difference(_ultimoTick).inMilliseconds;
    _ultimoTick = agora;

    // O tempo fica parado enquanto o resultado da resposta é exibido.
    if (_escolhido != null || _finalizado) return;

    setState(() => _restanteMs -= decorrido);
    if (_restanteMs <= 0) {
      _restanteMs = 0;
      _finalizar();
    }
  }

  void _responder(Pais opcao) {
    if (_escolhido != null || _finalizado) return;

    setState(() {
      _escolhido = opcao.codigo;
      _respondidas++;
      if (opcao.codigo == _pergunta.correto.codigo) _acertos++;
    });
    _animacao.forward(from: 0);

    _temporizadorProxima = Timer(_tempoFeedback, _proximaPergunta);
  }

  void _proximaPergunta() {
    if (!mounted || _finalizado) return;
    setState(() {
      _pergunta = _gerador!.proxima();
      _escolhido = null;
    });
    _ultimoTick = DateTime.now();
  }

  /// Tempo acabou: mostra um aviso rápido e abre a tela de resultados.
  void _finalizar() {
    if (_finalizado) return;
    _cronometro?.cancel();
    _temporizadorProxima?.cancel();
    setState(() => _finalizado = true);

    _temporizadorFim = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TelaResultados(
            resultado: ResultadoPartida(
              configuracao: widget.configuracao,
              totalRespondidas: _respondidas,
              acertos: _acertos,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _confirmarSaida() async {
    final textos = EscopoEstado.de(context).textos;
    final sair = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: Text(textos.t('jogo_sair_titulo')),
        content: Text(textos.t('jogo_sair_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: Text(textos.t('cancelar')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: Text(textos.t('sair')),
          ),
        ],
      ),
    );
    if (sair == true && mounted) Navigator.pop(context);
  }

  SituacaoResposta _situacao(Pais opcao) {
    if (_escolhido == null) return SituacaoResposta.normal;
    if (opcao.codigo == _pergunta.correto.codigo) {
      return SituacaoResposta.correta;
    }
    if (opcao.codigo == _escolhido) {
      return SituacaoResposta.errada;
    }
    return SituacaoResposta.desativada;
  }
  
  void _tocarSomResposta(Pais opcao){
    if(_escolhido != null){
       setState((){
          _escolhido = opcao.codigo;
       });
    }

    if(opcao.codigo == _pergunta.correto.codigo){
      _audioService.playCorrectSound();
    } else {
      _audioService.playWrongSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = EscopoEstado.de(context);
    final textos = estado.textos;
    final idioma = estado.idioma;

    final totalMs = widget.configuracao.duracaoSegundos * 1000;
    final fracao = (_restanteMs / totalMs).clamp(0.0, 1.0).toDouble();
    final segundos = (_restanteMs / 1000).ceil();
    final urgente = segundos <= 10;
    final corTempo = urgente ? const Color(0xFFC62828) : const Color(0xFF1565C0);

    final continente = widget.configuracao.continente;
    final titulo = continente == null
        ? textos.t('menu_aleatorio')
        : textos.continente(continente);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _finalizado ? null : _confirmarSaida,
        ),
        title: Text(titulo),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Pontuação e tempo restante.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${textos.t('jogo_pontos')}: '
                            '${_acertos * ResultadoPartida.pontosPorAcerto}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer, color: corTempo),
                              const SizedBox(width: 4),
                              Text(
                                _formatarTempo(segundos),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: corTempo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: fracao,
                            backgroundColor: const Color(0xFFCFD8DC),
                            valueColor: AlwaysStoppedAnimation<Color>(corTempo),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        textos.t('jogo_pergunta'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black54),
                      ),
                      // Bandeira no topo.
                      Expanded(child: _construirBandeira(textos, idioma)),
                      // Quatro opções de resposta.
                      for (final opcao in _pergunta.opcoes)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: BotaoResposta(
                            texto: opcao.nome(idioma),
                            situacao: _situacao(opcao),
                            aoTocar: (_escolhido != null || _finalizado)
                                ? null
                                : () {
                                    _responder(opcao);
                                    _tocarSomResposta(opcao);
                                  },
                          ),
                        ),
                    ],
                  ),
                  if (_finalizado) _construirFimDeTempo(textos),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatarTempo(int segundos) {
    final minutos = segundos ~/ 60;
    final resto = (segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$resto';
  }

  /// Bandeira com animação: pulsa ao acertar e treme ao errar.
  Widget _construirBandeira(Textos textos, String idioma) {
    final bandeira = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox.expand(
        child: Image.asset(
          _pergunta.correto.bandeira128,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animacao,
          child: bandeira,
          builder: (context, filho) {
            double deslocamentoX = 0;
            double escala = 1;
            if (_escolhido != null) {
              final t = _animacao.value;
              if (_acertou) {
                escala = 1 + 0.10 * sin(t * pi);
              } else {
                deslocamentoX = sin(t * pi * 6) * 14 * (1 - t);
              }
            }
            return Transform.translate(
              offset: Offset(deslocamentoX, 0),
              child: Transform.scale(scale: escala, child: filho),
            );
          },
        ),
        if (_escolhido != null) _construirFeedback(textos, idioma),
      ],
    );
  }

  /// Ícone e mensagem que aparecem sobre a bandeira após responder.
  Widget _construirFeedback(Textos textos, String idioma) {
    final cor = _acertou ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final mensagem = _acertou
        ? '${textos.t('jogo_acertou')} +${ResultadoPartida.pontosPorAcerto}'
        : textos.t('jogo_errou');

    return AnimatedBuilder(
      animation: _animacao,
      builder: (context, _) {
        final t = _animacao.value.clamp(0.0, 1.0).toDouble();
        final escala = Curves.elasticOut.transform(t);
        final opacidade = (t * 3).clamp(0.0, 1.0).toDouble();
        return Opacity(
          opacity: opacidade,
          child: Transform.scale(
            scale: escala,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cor, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_acertou ? Icons.check_circle : Icons.cancel,
                      size: 64, color: cor),
                  Text(
                    mensagem,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: cor),
                  ),
                  if (!_acertou)
                    Text(
                      textos.t('jogo_era',
                          {'nome': _pergunta.correto.nome(idioma)}),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _construirFimDeTempo(Textos textos) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          textos.t('jogo_tempo_esgotado'),
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }
}
