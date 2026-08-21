import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/coin.dart';
import '../../data/repositories/coin_repository.dart';
import '../../data/repositories/coin_repository_impl.dart';
import 'coin_list_state.dart';

class CoinListCubit extends Cubit<CoinListState> {
  CoinListCubit({
    CoinRepository? repository,
    int pageSize = 10,
    Duration? searchDebounce,
  }) : _repository = repository ?? const CoinRepositoryImpl(),
       _pageSize = pageSize,
       _searchDebounce = searchDebounce ?? const Duration(milliseconds: 1000),
       super(const CoinListState()) {
    _load(reset: true);
  }

  final CoinRepository _repository;
  final int _pageSize;
  final Duration _searchDebounce;
  Timer? _debounceTimer;
  int _requestId = 0;

  Future<void> loadMore() async {
    if (state.isLoading) return;
    final hasMore = state.isSearchMode ? state.searchHasMore : state.hasMore;
    if (!hasMore) return;
    await _load();
  }

  Future<void> refresh() async {
    if (state.isSearchMode) return;
    await _load(reset: true);
  }

  Future<void> retry() async {
    if (state.isLoading) return;
    await _load(reset: state.coins.isEmpty);
  }

  void onSearchChanged(String value) {
    final query = value.trim();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_searchDebounce, () => _applySearch(query));
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _applySearch('');
  }

  void _applySearch(String query) {
    if (isClosed) return;
    emit(
      state.copyWith(
        searchQuery: query,
        hasMore: true,
        searchHasMore: true,
        clearError: true,
      ),
    );
    _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    final requestId = ++_requestId;
    final query = state.searchQuery;
    final isSearchMode = query.isNotEmpty;
    final cursor = reset ? null : (isSearchMode ? state.searchCursor : state.cursor);

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final page = isSearchMode
          ? await _repository.searchCoins(
              keyword: query,
              limit: _pageSize,
              cursor: cursor,
            )
          : await _repository.fetchCoins(limit: _pageSize, cursor: cursor);

      if (isClosed || requestId != _requestId) return;

      final coins = reset ? page.coins : _mergeUnique(state.coins, page.coins);

      emit(
        state.copyWith(
          coins: coins,
          isLoading: false,
          cursor: isSearchMode ? state.cursor : page.nextCursor,
          clearCursor: !isSearchMode && page.nextCursor == null,
          searchCursor: isSearchMode ? page.nextCursor : state.searchCursor,
          clearSearchCursor: isSearchMode && page.nextCursor == null,
          hasMore: isSearchMode ? state.hasMore : page.hasNextPage,
          searchHasMore: isSearchMode ? page.hasNextPage : state.searchHasMore,
        ),
      );
    } catch (e) {
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  List<Coin> _mergeUnique(List<Coin> existing, List<Coin> incoming) {
    final existingUuids = existing.map((coin) => coin.uuid).toSet();
    final uniqueNewCoins = incoming.where((coin) => !existingUuids.contains(coin.uuid));
    return [...existing, ...uniqueNewCoins];
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
