import 'dart:convert';

import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/screens/coin_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CoinDetail', () {
    testWidgets('shows a loading indicator while the coin loads', (
      tester,
    ) async {
      final recorder = _RecordingCoinDetailApi(coin: _bitcoinJson);

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinDetail(coinId: 'bitcoin')));

        expect(find.byKey(const Key('CoinDetailContentBox')), findsOneWidget);

        await tester.pumpAndSettle();
      }, () => MockClient(recorder.handle));
    });

    testWidgets('renders the coin content once loaded', (tester) async {
      final recorder = _RecordingCoinDetailApi(coin: _bitcoinJson);

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinDetail(coinId: 'bitcoin')));
        await tester.pumpAndSettle();

        expect(recorder.requests.last.path, endsWith('/v2/coin/bitcoin'));
        expect(find.text('Coin Details'), findsOneWidget);
        expect(find.text('BTC'), findsOneWidget);
        expect(find.text('Bitcoin'), findsOneWidget);
        expect(find.text(r'$100.00'), findsOneWidget);
      }, () => MockClient(recorder.handle));
    });

    testWidgets('shows an error state and recovers after a successful retry', (
      tester,
    ) async {
      final recorder = _RecordingCoinDetailApi(
        coin: _bitcoinJson,
        failNext: true,
      );

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinDetail(coinId: 'bitcoin')));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);

        recorder.failNext = false;
        await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.text('BTC'), findsOneWidget);
      }, () => MockClient(recorder.handle));
    });

    testWidgets('pops the screen when the back button is tapped', (
      tester,
    ) async {
      final recorder = _RecordingCoinDetailApi(coin: _bitcoinJson);

      await http.runWithClient(() async {
        await tester.pumpWidget(
          _testApp(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CoinDetail(coinId: 'bitcoin'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.byType(CoinDetail), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.byType(CoinDetail), findsNothing);
      }, () => MockClient(recorder.handle));
    });
  });
}

class _RecordingCoinDetailApi {
  _RecordingCoinDetailApi({required this.coin, this.failNext = false});

  final Map<String, dynamic> coin;
  bool failNext;
  final List<Uri> requests = [];

  Future<http.Response> handle(http.Request request) async {
    requests.add(request.url);

    if (failNext) {
      return http.Response('Server error', 500);
    }

    return http.Response(
      jsonEncode({
        'data': {'coin': coin},
      }),
      200,
    );
  }
}

final _bitcoinJson = {
  'uuid': 'bitcoin',
  'symbol': 'BTC',
  'name': 'Bitcoin',
  'color': 'orange',
  'iconUrl': '',
  'marketCap': '1000000',
  'price': '100',
  'change': '1.5',
  'listedAt': 1,
  'tier': 1,
  'rank': 1,
  'lowVolume': false,
  'contractAddresses': <String>[],
  'isWrappedTrustless': false,
};

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
