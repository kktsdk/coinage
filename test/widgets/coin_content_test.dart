import 'package:coinage/data/models/coin.dart';
import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/coin_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders coin details and positive price change', (tester) async {
    final coin = _createCoin(
      description: 'A digital currency',
      price: '1234.5',
      marketCap: '2500000000',
      change: '2.5',
    );

    await tester.pumpWidget(_testApp(CoinContent(coin: coin)));

    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text(' (orange)'), findsNothing);
    expect(find.text(r'$1234.50'), findsOneWidget);
    expect(find.text('2.50%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    expect(find.text('Market Cap'), findsOneWidget);
    expect(find.text('2.50 billion'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('A digital currency'), findsOneWidget);
    expect(find.text('Go to Website'), findsNothing);
  });

  testWidgets('uses fallback description and renders website button', (
    tester,
  ) async {
    final coin = _createCoin(
      description: '  ',
      change: '-1.25',
      websiteUrl: 'https://example.com',
    );

    await tester.pumpWidget(_testApp(CoinContent(coin: coin)));

    expect(find.text('No description'), findsOneWidget);
    expect(find.text('1.25%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Go to Website'),
      findsOneWidget,
    );
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

Coin _createCoin({
  String? description,
  String? price = '1234.5',
  String? marketCap = '1000000',
  String? change = '0',
  String? websiteUrl,
}) {
  return Coin(
    uuid: 'bitcoin-uuid',
    symbol: 'BTC',
    name: 'Bitcoin',
    color: 'orange',
    iconUrl: '',
    marketCap: marketCap,
    description: description,
    websiteUrl: websiteUrl,
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
