import 'coin.dart';

class CoinsPage {
  final List<Coin> coins;
  final bool hasNextPage;
  final String? nextCursor;

  const CoinsPage({
    required this.coins,
    required this.hasNextPage,
    this.nextCursor,
  });

  factory CoinsPage.fromResponseBody(
    Map<String, dynamic> body, {
    required int requestedLimit,
  }) {
    final coinsJson = body['data']?['coins'] as List<dynamic>?;
    final pagination = body['pagination'] as Map<String, dynamic>?;

    final coins = coinsJson
            ?.map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList() ??
        <Coin>[];

    final hasNextPage = pagination != null
        ? (pagination['hasNextPage'] as bool?) ?? false
        : coins.length >= requestedLimit;
    final nextCursor = pagination?['nextCursor'] as String?;

    return CoinsPage(
      coins: coins,
      hasNextPage: hasNextPage,
      nextCursor: nextCursor,
    );
  }

  static const empty = CoinsPage(coins: [], hasNextPage: false);
}
