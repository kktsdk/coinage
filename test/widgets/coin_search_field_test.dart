import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/coin_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders hint text and hides the clear button when empty', (
    tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      _testApp(
        CoinSearchField(
          controller: controller,
          onChanged: (_) {},
          onClear: () {},
        ),
      ),
    );

    expect(find.text('Search coins'), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsNothing);
  });

  testWidgets('shows the clear button when text is present', (tester) async {
    final controller = TextEditingController(text: 'btc');

    await tester.pumpWidget(
      _testApp(
        CoinSearchField(
          controller: controller,
          onChanged: (_) {},
          onClear: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.clear), findsOneWidget);
  });

  testWidgets('invokes onChanged as the user types', (tester) async {
    final controller = TextEditingController();
    final changes = <String>[];

    await tester.pumpWidget(
      _testApp(
        CoinSearchField(
          controller: controller,
          onChanged: changes.add,
          onClear: () {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'eth');

    expect(changes, ['eth']);
  });

  testWidgets('invokes onClear when the clear button is tapped', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'btc');
    var clearCount = 0;

    await tester.pumpWidget(
      _testApp(
        CoinSearchField(
          controller: controller,
          onChanged: (_) {},
          onClear: () => clearCount++,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(clearCount, 1);
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
