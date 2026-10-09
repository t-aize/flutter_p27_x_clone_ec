// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:x_clone_ec/models/quote.dart';
import 'package:x_clone_ec/pages/home.dart';
import 'package:x_clone_ec/persistence/settings_persistence.dart';

import 'package:x_clone_ec/main.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('settings are read by a new persistence instance', () async {
    expect(await SettingsPersistence().loadSettings(), {
      'username': '',
      'backgroundImage': '',
    });
    await SettingsPersistence().saveSettings(
      'eleve@example.fr',
      'assets/avatars/thomas.jpg',
    );
    expect(await SettingsPersistence().loadSettings(), {
      'username': 'eleve@example.fr',
      'backgroundImage': 'assets/avatars/thomas.jpg',
    });
  });

  test('parses normal and rate limit responses, rejects invalid JSON', () {
    expect(Quote.fromJSON('[{"q":"Bonjour","a":"Auteur"}]').text, 'Bonjour');
    expect(
      Quote.fromJSON('{"q":"Too many requests","a":"zenquotes.io"}').author,
      'zenquotes.io',
    );
    for (final json in ['[]', '{}', '{"q":42,"a":"Auteur"}', 'invalid']) {
      expect(() => Quote.fromJSON(json), throwsFormatException);
    }
  });

  testWidgets('validates login fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Entrez votre email'), findsOneWidget);
    expect(find.text('Entrez votre mot de passe'), findsOneWidget);
  });

  testWidgets('rejects invalid email and short password', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'invalide');
    await tester.enterText(find.byType(TextFormField).at(1), 'court');
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Entrez une adresse email valide'), findsOneWidget);
    expect(
      find.text('Entrez un mot de passe plus long (12 caractères minimum)'),
      findsOneWidget,
    );
    expect(find.byType(Home), findsNothing);
  });

  testWidgets('toggles password and replaces login with home', (tester) async {
    await tester.pumpWidget(const MyApp());
    final password = find.byType(TextFormField).at(1);
    expect(
      tester.widget<EditableText>(find.byType(EditableText).at(1)).obscureText,
      isTrue,
    );
    await tester.tap(find.byTooltip('Afficher le mot de passe'));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText).at(1)).obscureText,
      isFalse,
    );
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'eleve@example.fr',
    );
    await tester.enterText(password, '123456789012');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Entrez vos identifiants'), findsNothing);
    expect(find.text('Marie Dupont'), findsOneWidget);
    expect(await SettingsPersistence().loadSettings(), {
      'username': 'eleve@example.fr',
      'backgroundImage': 'assets/avatars/marie.jpg',
    });
    await tester.tap(find.text('Abonnements'));
    await tester.pumpAndSettle();
    expect(find.text('Abonnements'), findsNWidgets(2));
    await tester.tap(find.byTooltip('Paramètres'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bleu nuit'));
    await tester.pumpAndSettle();
    expect(find.text('Couleur sauvegardée'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Couleur du fond')))
          .scaffoldBackgroundColor,
      const Color(0xff15202b),
    );
    expect(await SettingsPersistence().loadBackgroundColor(), 0xff15202b);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Home))).scaffoldBackgroundColor,
      const Color(0xff15202b),
    );

    // Recreate the app while retaining the simulated preference store.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Entrez vos identifiants')))
          .scaffoldBackgroundColor,
      const Color(0xff15202b),
    );
    expect(await SettingsPersistence().loadSettings(), {
      'username': 'eleve@example.fr',
      'backgroundImage': 'assets/avatars/marie.jpg',
    });
  });
}
