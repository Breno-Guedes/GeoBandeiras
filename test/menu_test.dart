import 'dart:io';

import 'package:flutter_flags_quiz/estado/estado_app.dart';
import 'package:flutter_flags_quiz/main.dart';
import 'package:flutter_flags_quiz/servicos/repositorio_paises.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('menu principal mostra as opções de jogo', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final paises = RepositorioPaises.interpretar(
        File('assets/dados/paises.json').readAsStringSync());
    final estado = EstadoApp(paises: paises);

    await tester.pumpWidget(JogoBandeirasApp(estado: estado));
    await tester.pump();

    expect(find.text('Jogar por Continente'), findsOneWidget);
    expect(find.text('Jogo Aleatório'), findsOneWidget);
    expect(find.text('Configuração do Tempo'), findsOneWidget);
  });
}
