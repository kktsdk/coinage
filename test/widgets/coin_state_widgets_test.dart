import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/coin_state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoinLoadingIndicator', () {
    testWidgets('renders a progress indicator', (tester) async {
      await tester.pumpWidget(_testApp(const CoinLoadingIndicator()));

      expect(find.byKey(const Key('CoinsBox')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('CoinEmptyState', () {
    testWidgets('renders the no results message', (tester) async {
      await tester.pumpWidget(_testApp(const CoinEmptyState()));

      expect(find.text('No results found'), findsOneWidget);
    });
  });

  group('CoinErrorState', () {
    testWidgets('renders the error message and retry button', (tester) async {
      await tester.pumpWidget(
        _testApp(
          CoinErrorState(message: 'Something went wrong', onRetry: () {}),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('invokes onRetry when the retry button is tapped', (
      tester,
    ) async {
      var retryCount = 0;

      await tester.pumpWidget(
        _testApp(
          CoinErrorState(
            message: 'Something went wrong',
            onRetry: () => retryCount++,
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
      await tester.pump();

      expect(retryCount, 1);
    });
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
