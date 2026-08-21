import 'package:coinage/presentation/widgets/coin_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY'
    '42YAAAAASUVORK5CYII=';

void main() {
  testWidgets('renders fallback icon when url is empty', (tester) async {
    await tester.pumpWidget(_testApp(const CoinIcon(url: '', size: 40)));

    expect(find.byIcon(Icons.monetization_on_outlined), findsOneWidget);
    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.width, 40);
    expect(sizedBox.height, 40);
  });

  testWidgets('renders fallback icon when url is whitespace only', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const CoinIcon(url: '   ', size: 32)));

    expect(find.byIcon(Icons.monetization_on_outlined), findsOneWidget);
  });

  testWidgets('renders inline SVG content from a data URI', (tester) async {
    const svgMarkup =
        '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10">'
        '<rect width="10" height="10" fill="red"/></svg>';
    final dataUri = 'data:image/svg+xml,${Uri.encodeComponent(svgMarkup)}';

    await tester.pumpWidget(_testApp(CoinIcon(url: dataUri, size: 48)));

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byIcon(Icons.monetization_on_outlined), findsNothing);
  });

  testWidgets('renders inline PNG content from a data URI', (tester) async {
    final dataUri = 'data:image/png;base64,$_pngBase64';

    await tester.pumpWidget(_testApp(CoinIcon(url: dataUri, size: 24)));

    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}
