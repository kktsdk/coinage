import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';
import '../models/coins_page.dart';

const _baseUrl = 'https://api.coinranking.com';
const _coinRankingPath = '/v2/coins';
const _coinDetailPath = '/v2/coin/';
const _coinRankingToken = String.fromEnvironment('COINRANKING_API_KEY');

const Map<String, String> _headers = <String, String>{
  'Authorization': 'Bearer $_coinRankingToken',
  'Content-Type': 'application/json',
};

class CoinRemoteDataSource {
  const CoinRemoteDataSource();

  Future<CoinsPage> fetchCoinsPage({int limit = 10, String? cursor}) {
    return _getCoinsPage({
      'limit': limit.toString(),
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
    });
  }

  Future<CoinsPage> searchCoinsPage({
    required String keyword,
    int limit = 10,
    String? cursor,
  }) {
    final searchTerm = keyword.trim();
    if (searchTerm.isEmpty) {
      return Future.value(CoinsPage.empty);
    }

    return _getCoinsPage({
      'limit': limit.toString(),
      'search': searchTerm,
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
    });
  }

  Future<Coin> getCoinByUuid(String uuid) async {
    final uri = Uri.parse(_baseUrl + _coinDetailPath + uuid);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to load coin: ${response.statusCode}');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final coinJson = body['data']?['coin'] as Map<String, dynamic>?;

    if (coinJson == null) {
      throw Exception('Coin detail payload is missing');
    }

    return Coin.fromJson(coinJson);
  }

  Future<CoinsPage> _getCoinsPage(Map<String, String> queryParameters) async {
    final uri = Uri.parse(
      _baseUrl + _coinRankingPath,
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to load coins: ${response.statusCode}');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final limit = int.tryParse(queryParameters['limit'] ?? '') ?? 10;
    return CoinsPage.fromResponseBody(body, requestedLimit: limit);
  }
}
