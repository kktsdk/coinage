import '../models/coin.dart';
import '../models/coins_page.dart';

abstract class CoinRepository {
  Future<CoinsPage> fetchCoins({int limit = 10, String? cursor});

  Future<CoinsPage> searchCoins({
    required String keyword,
    int limit = 10,
    String? cursor,
  });

  Future<Coin> getCoinById(String id);
}
