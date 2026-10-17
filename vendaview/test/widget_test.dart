import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vendaview/main.dart';
import 'package:vendaview/screens/home_screen.dart';
import 'package:vendaview/services/auth_service.dart';

void main() {
  testWidgets('Login valida campos vazios', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Digite o e-mail da sua loja'), findsOneWidget);
    expect(find.text('Digite a senha da sua loja'), findsOneWidget);
  });

  testWidgets('Login com credenciais inválidas mostra erro',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'x@loja.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'errada');
    await tester.tap(find.text('Entrar'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('E-mail ou senha inválidos.'), findsOneWidget);
  });

  testWidgets('Login com credenciais demo abre a HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(
        find.byType(TextFormField).at(0), AuthService.emailDemo);
    await tester.enterText(
        find.byType(TextFormField).at(1), AuthService.senhaDemo);
    await tester.tap(find.text('Entrar'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
