import 'package:coinage/data/models/coin.dart';
import 'package:coinage/presentation/widgets/coin_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders coin details and positive price change', (tester) async {
    final coin = _createCoin(price: '1234.5', change: '2.5');

    await tester.pumpWidget(
      _testApp(CoinListItem(coin: coin, index: 0, onTap: () {})),
    );

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text(' (orange)'), findsNothing);
    expect(find.text(r'$1234.50'), findsOneWidget);
    expect(find.text('2.50%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    expect(find.byKey(const Key('coin-item-0')), findsOneWidget);
  });

  testWidgets('keeps a long coin name from overflowing on a narrow screen', (
    tester,
  ) async {
    final coin = _createCoin();
    final longNameCoin = Coin(
      uuid: coin.uuid,
      symbol: coin.symbol,
      name: 'A Very Long Coin Name That Should Not Overflow The Row',
      color: coin.color,
      iconUrl: coin.iconUrl,
      marketCap: coin.marketCap,
      description: coin.description,
      price: coin.price,
      change: coin.change,
      rank: coin.rank,
      sparkline: coin.sparkline,
      contractAddresses: coin.contractAddresses,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(200, 800)),
        child: _testApp(
          CoinListItem(coin: longNameCoin, index: 0, onTap: () {}),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders negative price change with the down arrow', (
    tester,
  ) async {
    final coin = _createCoin(change: '-1.25');

    await tester.pumpWidget(
      _testApp(CoinListItem(coin: coin, index: 2, onTap: () {})),
    );

    expect(find.text('1.25%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    expect(find.byKey(const Key('coin-item-2')), findsOneWidget);
  });

  testWidgets('invokes onTap when the item is tapped', (tester) async {
    var tapCount = 0;
    final coin = _createCoin();

    await tester.pumpWidget(
      _testApp(CoinListItem(coin: coin, index: 0, onTap: () => tapCount++)),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapCount, 1);
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

Coin _createCoin({String? price = '1234.5', String? change = '0'}) {
  return Coin(
    uuid: 'bitcoin-uuid',
    symbol: 'BTC',
    name: 'Bitcoin',
    color: 'orange',
    iconUrl: '',
    marketCap: '1000000',
    description: 'A digital currency',
    price: price,
    listedAt: 1,
    tier: 1,
    change: change,
    rank: 1,
    sparkline: const [],
    lowVolume: false,
    contractAddresses: const [],
    isWrappedTrustless: false,
  );
}
