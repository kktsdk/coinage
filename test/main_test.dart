import 'dart:convert';

import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/main.dart';
import 'package:coinage/presentation/screens/coin_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<T> _withMockClient<T>(Future<T> Function() body) {
  return http.runWithClient(
    body,
    () => MockClient((request) async {
      return http.Response(
        jsonEncode({
          'data': {'coins': <Map<String, dynamic>>[]},
          'pagination': {'hasNextPage': false, 'nextCursor': null},
        }),
        200,
      );
    }),
  );
}

void main() {
  group('MyApp', () {
    testWidgets('renders MyApp successfully', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        expect(find.byType(MyApp), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    testWidgets('uses Coinage as app title', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );

        expect(materialApp.title, 'Coinage');
      });
    });

    testWidgets('uses CoinList as home screen', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        expect(find.byType(CoinList), findsOneWidget);
      });
    });

    testWidgets('configures supported locales', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );

        expect(
          materialApp.supportedLocales,
          AppLocalizations.supportedLocales,
        );
      });
    });

    testWidgets('configures localization delegates', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );

        expect(
          materialApp.localizationsDelegates,
          contains(AppLocalizations.delegate),
        );

        expect(
          materialApp.localizationsDelegates,
          contains(GlobalMaterialLocalizations.delegate),
        );

        expect(
          materialApp.localizationsDelegates,
          contains(GlobalWidgetsLocalizations.delegate),
        );

        expect(
          materialApp.localizationsDelegates,
          contains(GlobalCupertinoLocalizations.delegate),
        );
      });
    });

    testWidgets('supports English locale', (tester) async {
      await _withMockClient(() async {
        await tester.pumpWidget(const MyApp());

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );

        expect(materialApp.supportedLocales, contains(const Locale('en')));
      });
    });
  });
}
