import 'dart:convert';

import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/screens/coin_list.dart';
import 'package:coinage/presentation/widgets/coin_list_item.dart';
import 'package:coinage/presentation/widgets/coin_state_widgets.dart';
import 'package:coinage/presentation/widgets/invite_friends_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CoinList', () {
    testWidgets('shows a loading indicator while the first page loads', (
      tester,
    ) async {
      final recorder = _RecordingCoinApi(coins: _coinsRankOneToSix);

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinList()));

        expect(find.byType(CoinLoadingIndicator), findsOneWidget);

        await tester.pumpAndSettle();
      }, () => MockClient(recorder.handle));
    });

    testWidgets('renders the top 3 coins and the remaining coin list', (
      tester,
    ) async {
      final recorder = _RecordingCoinApi(coins: _coinsRankOneToSix);

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinList()));
        await tester.pumpAndSettle();

        expect(find.text('Top 3 Coins'), findsOneWidget);
        expect(find.text('Coins'), findsOneWidget);
        expect(find.byType(CoinListItem), findsNWidgets(6));
        expect(find.text('C1'), findsOneWidget);
        expect(find.text('C6'), findsOneWidget);
      }, () => MockClient(recorder.handle));
    });

    testWidgets('searches by keyword and restores the list on clear', (
      tester,
    ) async {
      final recorder = _RecordingCoinApi(
        coins: _coinsRankOneToSix,
        searchResultsByKeyword: {
          'c4': [
            _coinJson(uuid: 'coin-4', symbol: 'C4', name: 'Coin 4', rank: 4),
          ],
        },
      );

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinList()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'C4');
        await tester.pump(const Duration(milliseconds: 1000));
        await tester.pumpAndSettle();

        expect(recorder.requests.last.queryParameters['search'], 'C4');
        expect(find.text('Top 3 Coins'), findsNothing);
        expect(find.byType(CoinListItem), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(CoinListItem),
            matching: find.text('C4'),
          ),
          findsOneWidget,
        );
        expect(find.text('C1'), findsNothing);

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pumpAndSettle();

        expect(find.text('Top 3 Coins'), findsOneWidget);
        expect(find.byType(CoinListItem), findsNWidgets(6));
      }, () => MockClient(recorder.handle));
    });

    testWidgets('shows an error state and recovers after a successful retry', (
      tester,
    ) async {
      final recorder = _RecordingCoinApi(
        coins: _coinsRankOneToSix,
        failNext: true,
      );

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinList()));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);

        recorder.failNext = false;
        await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.byType(CoinListItem), findsNWidgets(6));
      }, () => MockClient(recorder.handle));
    });

    testWidgets('shows an empty state when no coins are returned', (
      tester,
    ) async {
      final recorder = _RecordingCoinApi(coins: const []);

      await http.runWithClient(() async {
        await tester.pumpWidget(_testApp(const CoinList()));
        await tester.pumpAndSettle();

        expect(find.text('No results found'), findsOneWidget);
      }, () => MockClient(recorder.handle));
    });

    testWidgets(
      'inserts Invite Friends as row 5 instead of after the 5th coin',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(800, 2000));

        final coins = List.generate(
          8,
          (i) => _coinJson(
            uuid: 'coin-${i + 1}',
            symbol: 'C${i + 1}',
            name: 'Coin ${i + 1}',
            rank: i + 1,
          ),
        );
        final recorder = _RecordingCoinApi(coins: coins);

        await http.runWithClient(() async {
          await tester.pumpWidget(_testApp(const CoinList()));
          await tester.pumpAndSettle();

          final order = tester
              .widgetList(
                find.byWidgetPredicate(
                  (widget) => widget is CoinListItem || widget is InviteFriendsItem,
                ),
              )
              .map((widget) => widget is CoinListItem ? widget.coin.symbol : 'INVITE')
              .toList();

          expect(order, [
            'C1',
            'C2',
            'C3',
            'C4',
            'C5',
            'C6',
            'C7',
            'INVITE',
            'C8',
          ]);
        }, () => MockClient(recorder.handle));
      },
    );

    testWidgets(
      'shifts later invite positions after an earlier one is inserted',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(800, 3000));

        // Ranks 4-13 are the 10 coins visible below Top 3, enough to trigger
        // both the row-5 and row-10 invite positions.
        final coins = List.generate(
          13,
          (i) => _coinJson(
            uuid: 'coin-${i + 1}',
            symbol: 'C${i + 1}',
            name: 'Coin ${i + 1}',
            rank: i + 1,
          ),
        );
        final recorder = _RecordingCoinApi(coins: coins);

        await http.runWithClient(() async {
          await tester.pumpWidget(_testApp(const CoinList()));
          await tester.pumpAndSettle();

          final order = tester
              .widgetList(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is CoinListItem || widget is InviteFriendsItem,
                ),
              )
              .map(
                (widget) =>
                    widget is CoinListItem ? widget.coin.symbol : 'INVITE',
              )
              .toList();

          expect(order, [
            'C1', 'C2', 'C3',
            'C4', 'C5', 'C6', 'C7', 'INVITE',
            'C8', 'C9', 'C10', 'C11', 'INVITE',
            'C12', 'C13',
          ]);
        }, () => MockClient(recorder.handle));
      },
    );
  });
}

class _RecordingCoinApi {
  _RecordingCoinApi({
    required this.coins,
    this.searchResultsByKeyword = const {},
    this.failNext = false,
  });

  final List<Map<String, dynamic>> coins;
  final Map<String, List<Map<String, dynamic>>> searchResultsByKeyword;
  bool failNext;
  final List<Uri> requests = [];

  Future<http.Response> handle(http.Request request) async {
    requests.add(request.url);

    if (failNext) {
      return http.Response('Server error', 500);
    }

    final search = request.url.queryParameters['search'];
    final data = search != null
        ? (searchResultsByKeyword[search.toLowerCase()] ??
              const <Map<String, dynamic>>[])
        : coins;

    return http.Response(
      jsonEncode({
        'data': {'coins': data},
        'pagination': {'hasNextPage': false, 'nextCursor': null},
      }),
      200,
    );
  }
}

final _coinsRankOneToSix = List.generate(
  6,
  (i) => _coinJson(
    uuid: 'coin-${i + 1}',
    symbol: 'C${i + 1}',
    name: 'Coin ${i + 1}',
    rank: i + 1,
  ),
);

Map<String, dynamic> _coinJson({
  required String uuid,
  required String symbol,
  required String name,
  required int rank,
}) {
  return {
    'uuid': uuid,
    'symbol': symbol,
    'name': name,
    'color': 'orange',
    'iconUrl': '',
    'marketCap': '1000000',
    'price': '100',
    'change': '1.5',
    'listedAt': 1,
    'tier': 1,
    'rank': rank,
    'lowVolume': false,
    'contractAddresses': <String>[],
    'isWrappedTrustless': false,
  };
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
