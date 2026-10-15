import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localizacao/textos.dart';
import '../modelos/pais.dart';
import '../servicos/audioGlobal.dart';

/// Estado global do aplicativo: banco de países e preferências do jogador.
/// As preferências (tempo, dificuldade, idioma e nome) ficam salvas no aparelho.
class EstadoApp extends ChangeNotifier {
  static const List<int> temposDisponiveis = [30, 60, 180, 300];

  final List<Pais> paises;

  String _idioma = 'pt';
  int _tempoSegundos = 60;
  Dificuldade _dificuldade = Dificuldade.facil;
  String _nomeJogador = '';
  double _volumeMusica = 0.5;

  EstadoApp({required this.paises});

  String get idioma => _idioma;
  int get tempoSegundos => _tempoSegundos;
  Dificuldade get dificuldade => _dificuldade;
  String get nomeJogador => _nomeJogador;
  double get volumeMusica => _volumeMusica;
  Textos get textos => Textos(_idioma);

  Future<void> carregarPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idioma = prefs.getString('idioma');
      if (idioma != null && Textos.idiomasDisponiveis.contains(idioma)) {
        _idioma = idioma;
      }
      final tempo = prefs.getInt('tempo');
      if (tempo != null && temposDisponiveis.contains(tempo)) {
        _tempoSegundos = tempo;
      }
      final dificuldade = prefs.getString('dificuldade');
      if (dificuldade != null) {
        for (final d in Dificuldade.values) {
          if (d.name == dificuldade) _dificuldade = d;
        }
      }
      _nomeJogador = prefs.getString('nome') ?? '';
      final volume = prefs.getDouble('volume_musica');
      if (volume != null) {
        _volumeMusica = volume.clamp(0.0, 1.0).toDouble();
        await AudioGlobal().setVolume(_volumeMusica);
      }
    } catch (_) {
      // Se não for possível ler, mantém os valores padrão.
    }
  }

  Future<void> definirIdioma(String idioma) async {
    _idioma = idioma;
    notifyListeners();
    await _salvarTexto('idioma', idioma);
  }

  Future<void> definirTempo(int segundos) async {
    _tempoSegundos = segundos;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tempo', segundos);
    } catch (_) {}
  }

  Future<void> definirDificuldade(Dificuldade dificuldade) async {
    _dificuldade = dificuldade;
    notifyListeners();
    await _salvarTexto('dificuldade', dificuldade.name);
  }

  Future<void> definirNomeJogador(String nome) async {
    _nomeJogador = nome;
    await _salvarTexto('nome', nome);
  }

  Future<void> definirVolumeMusica(double volume) async {
    _volumeMusica = volume.clamp(0.0, 1.0).toDouble();
    notifyListeners();
    await AudioGlobal().setVolume(_volumeMusica);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('volume_musica', _volumeMusica);
    } catch (_) {}
  }

  Future<void> _salvarTexto(String chave, String valor) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(chave, valor);
    } catch (_) {}
  }
}

/// Permite acessar o [EstadoApp] de qualquer tela: `EscopoEstado.de(context)`.
class EscopoEstado extends InheritedNotifier<EstadoApp> {
  const EscopoEstado({
    super.key,
    required EstadoApp estado,
    required super.child,
  }) : super(notifier: estado);

  static EstadoApp de(BuildContext context) {
    final escopo = context.dependOnInheritedWidgetOfExactType<EscopoEstado>();
    assert(escopo != null, 'EscopoEstado não encontrado na árvore de widgets');
    return escopo!.notifier!;
  }
}
