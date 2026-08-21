import '../../data/models/coin.dart';

class CoinListState {
  final List<Coin> coins;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final bool searchHasMore;
  final String? cursor;
  final String? searchCursor;
  final String searchQuery;

  const CoinListState({
    this.coins = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.searchHasMore = true,
    this.cursor,
    this.searchCursor,
    this.searchQuery = '',
  });

  bool get isSearchMode => searchQuery.isNotEmpty;

  List<Coin> get topCoins {
    if (isSearchMode || coins.isEmpty) return const [];
    final topThree = coins.where((coin) => coin.rank > 0 && coin.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return topThree;
  }

  List<Coin> get visibleCoins {
    if (isSearchMode) return coins;
    return coins.where((coin) => coin.rank > 3).toList();
  }

  CoinListState copyWith({
    List<Coin>? coins,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? hasMore,
    bool? searchHasMore,
    String? cursor,
    bool clearCursor = false,
    String? searchCursor,
    bool clearSearchCursor = false,
    String? searchQuery,
  }) {
    return CoinListState(
      coins: coins ?? this.coins,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hasMore: hasMore ?? this.hasMore,
      searchHasMore: searchHasMore ?? this.searchHasMore,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      searchCursor: clearSearchCursor ? null : (searchCursor ?? this.searchCursor),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
