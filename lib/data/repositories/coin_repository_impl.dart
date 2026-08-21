import '../datasources/coin_remote_data_source.dart';
import '../models/coin.dart';
import '../models/coins_page.dart';
import 'coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  const CoinRepositoryImpl({
    CoinRemoteDataSource dataSource = const CoinRemoteDataSource(),
  }) : _dataSource = dataSource;

  final CoinRemoteDataSource _dataSource;

  @override
  Future<CoinsPage> fetchCoins({int limit = 10, String? cursor}) {
    return _dataSource.fetchCoinsPage(limit: limit, cursor: cursor);
  }

  @override
  Future<CoinsPage> searchCoins({
    required String keyword,
    int limit = 10,
    String? cursor,
  }) {
    return _dataSource.searchCoinsPage(
      keyword: keyword,
      limit: limit,
      cursor: cursor,
    );
  }

  @override
  Future<Coin> getCoinById(String id) {
    return _dataSource.getCoinByUuid(id);
  }
}
