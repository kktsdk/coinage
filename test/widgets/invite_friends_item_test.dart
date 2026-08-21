import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/invite_friends_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _shareChannel = MethodChannel('dev.fluttercommunity.plus/share');

void main() {
  final shareCalls = <MethodCall>[];

  setUp(() {
    shareCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_shareChannel, (call) async {
          shareCalls.add(call);
          return 'dev.fluttercommunity.plus/share/success';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_shareChannel, null);
  });

  testWidgets('renders the invite label, icons and divider', (tester) async {
    await tester.pumpWidget(_testApp(const InviteFriendsItem()));

    expect(find.text('Invite Friends'), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt_1_rounded), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('shares the invite URL when tapped', (tester) async {
    await tester.pumpWidget(_testApp(const InviteFriendsItem()));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(shareCalls, hasLength(1));
    expect(shareCalls.single.method, 'share');
    expect(
      (shareCalls.single.arguments as Map)['text'],
      InviteFriendsItem.inviteUrl,
    );
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [AppLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
