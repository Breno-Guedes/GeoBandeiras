import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'estado/estado_app.dart';
import 'servicos/repositorio_paises.dart';
import 'telas/tela_menu.dart';
import 'servicos/audioGlobal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final paises = await RepositorioPaises.carregar();
  final estado = EstadoApp(paises: paises);
  await estado.carregarPreferencias();

  await AudioGlobal().playBackgroundMusic('audio/background_music.mp3');

  runApp(JogoBandeirasApp(estado: estado));
}

class JogoBandeirasApp extends StatefulWidget {
  final EstadoApp estado;

  const JogoBandeirasApp({super.key, required this.estado});

  @override
  State<JogoBandeirasApp> createState() => _JogoBandeirasAppState();
}

class _JogoBandeirasAppState extends State<JogoBandeirasApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(AudioGlobal().resumeMusic());
    } else {
      unawaited(AudioGlobal().pauseMusic());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EscopoEstado(
      estado: widget.estado,
      // Reconstrói o MaterialApp quando o idioma muda.
      child: AnimatedBuilder(
        animation: widget.estado,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GeoBandeiras',
            locale: Locale(widget.estado.idioma),
            supportedLocales: const [
              Locale('pt'),
              Locale('en'),
              Locale('es'),
            ],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1565C0),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
            ),
            home: const TelaMenu(),
          );
        },
      ),
    );
  }
}
