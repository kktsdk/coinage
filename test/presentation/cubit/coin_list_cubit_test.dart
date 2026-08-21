import 'package:coinage/data/models/coin.dart';
import 'package:coinage/data/models/coins_page.dart';
import 'package:coinage/data/repositories/coin_repository.dart';
import 'package:coinage/presentation/cubit/coin_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoinListCubit', () {
    test('loads the first page on creation', () async {
      final repository = _FakeCoinRepository(coins: _coins(count: 6));
      final cubit = CoinListCubit(
        repository: repository,
        searchDebounce: Duration.zero,
      );
      addTearDown(cubit.close);

      await pumpEventQueue();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.error, isNull);
      expect(cubit.state.coins, hasLength(6));
    });

    test('searches by keyword after the debounce fires', () async {
      final repository = _FakeCoinRepository(
        coins: _coins(count: 3),
        searchResults: {
          'eth': _coins(count: 1, prefix: 'search'),
        },
      );
      final cubit = CoinListCubit(
        repository: repository,
        searchDebounce: Duration.zero,
      );
      addTearDown(cubit.close);
      await pumpEventQueue();

      cubit.onSearchChanged('eth');
      await pumpEventQueue();

      expect(cubit.state.isSearchMode, isTrue);
      expect(cubit.state.coins, hasLength(1));
      expect(repository.searchCallCount, 1);
    });

    test('surfaces repository failures as an error state', () async {
      final repository = _FakeCoinRepository(coins: _coins(count: 3))
        ..failNext = true;
      final cubit = CoinListCubit(
        repository: repository,
        searchDebounce: Duration.zero,
      );
      addTearDown(cubit.close);

      await pumpEventQueue();

      expect(cubit.state.error, isNotNull);
      expect(cubit.state.coins, isEmpty);
    });
  });
}

class _FakeCoinRepository implements CoinRepository {
  _FakeCoinRepository({required this.coins, this.searchResults = const {}});

  final List<Coin> coins;
  final Map<String, List<Coin>> searchResults;
  bool failNext = false;
  int searchCallCount = 0;

  @override
  Future<CoinsPage> fetchCoins({int limit = 10, String? cursor}) async {
    if (failNext) {
      failNext = false;
      throw Exception('network error');
    }
    return CoinsPage(coins: coins, hasNextPage: false);
  }

  @override
  Future<CoinsPage> searchCoins({
    required String keyword,
    int limit = 10,
    String? cursor,
  }) async {
    searchCallCount++;
    return CoinsPage(coins: searchResults[keyword] ?? const [], hasNextPage: false);
  }

  @override
  Future<Coin> getCoinById(String id) => throw UnimplementedError();
}

List<Coin> _coins({required int count, String prefix = 'coin'}) {
  return List.generate(count, (i) {
    final rank = i + 1;
    return Coin(
      uuid: '$prefix-$rank',
      symbol: 'C$rank',
      name: 'Coin $rank',
      iconUrl: '',
      rank: rank,
      sparkline: const [],
      contractAddresses: const [],
    );
  });
}
