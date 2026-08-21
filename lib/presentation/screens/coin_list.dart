import 'package:coinage/data/models/coin.dart';
import 'package:coinage/data/repositories/coin_repository.dart';
import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/cubit/coin_list_cubit.dart';
import 'package:coinage/presentation/cubit/coin_list_state.dart';
import 'package:coinage/presentation/screens/coin_detail.dart';
import 'package:coinage/presentation/widgets/coin_list_item.dart';
import 'package:coinage/presentation/widgets/coin_search_field.dart';
import 'package:coinage/presentation/widgets/coin_state_widgets.dart';
import 'package:coinage/presentation/widgets/invite_friends_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinList extends StatelessWidget {
  final CoinRepository? repository;

  const CoinList({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoinListCubit(repository: repository),
      child: const _CoinListView(),
    );
  }
}

class _CoinListView extends StatefulWidget {
  const _CoinListView();

  @override
  State<_CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<_CoinListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CoinListCubit>().loadMore();
    }
  }

  void _onClear() {
    _searchController.clear();
    context.read<CoinListCubit>().clearSearch();
  }

  void _openDetail(BuildContext context, Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'detail'),
        builder: (context) => CoinDetail(coinId: coin.uuid),
      ),
    );
  }

  List<Object> _buildDisplayItems(List<Coin> coins) {
    final displayItems = <Object>[];
    var nextInvitePosition = 5;
    var coinIndex = 0;

    while (coinIndex < coins.length) {
      final currentRow = displayItems.length + 1;
      if (currentRow == nextInvitePosition) {
        displayItems.add(const InviteFriendsItem());
        nextInvitePosition *= 2;
      } else {
        displayItems.add(coins[coinIndex]);
        coinIndex++;
      }
    }

    return displayItems;
  }

  Widget _buildTopCoinsSection(
    BuildContext context,
    List<Coin> topCoins,
    AppLocalizations localizations,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.topCoinsTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < topCoins.length; index++)
            CoinListItem(
              coin: topCoins[index],
              index: index,
              onTap: () => _openDetail(context, topCoins[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CoinListState state,
    AppLocalizations localizations,
  ) {
    final cubit = context.read<CoinListCubit>();

    if (state.isLoading && state.coins.isEmpty) {
      return const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: CoinLoadingIndicator(),
          ),
        ],
      );
    }

    if (state.error != null && state.coins.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: CoinErrorState(
              message: state.error ?? localizations.somethingWentWrong,
              onRetry: cubit.retry,
            ),
          ),
        ],
      );
    }

    final visibleCoins = state.visibleCoins;

    if (state.coins.isEmpty || (visibleCoins.isEmpty && !state.isLoading)) {
      return const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: CoinEmptyState()),
        ],
      );
    }

    final displayItems = _buildDisplayItems(visibleCoins);

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (state.error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: CoinErrorState(
                message: state.error ?? localizations.somethingWentWrong,
                onRetry: cubit.retry,
              ),
            ),
          ),
        if (!state.isSearchMode && state.topCoins.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildTopCoinsSection(
              context,
              state.topCoins,
              localizations,
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              localizations.coinsSectionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = displayItems[index];
              if (item is InviteFriendsItem) return item;

              final coin = item as Coin;
              final coinIndex = displayItems
                  .sublist(0, index)
                  .whereType<Coin>()
                  .length;

              return CoinListItem(
                coin: coin,
                index: coinIndex,
                onTap: () => _openDetail(context, coin),
              );
            }, childCount: displayItems.length),
          ),
        ),
        if (state.isLoading)
          const SliverToBoxAdapter(child: CoinLoadingIndicator()),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CoinSearchField(
                controller: _searchController,
                onChanged: (value) =>
                    context.read<CoinListCubit>().onSearchChanged(value),
                onClear: _onClear,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<CoinListCubit, CoinListState>(
                  builder: (context, state) {
                    return RefreshIndicator(
                      notificationPredicate: (_) => !state.isSearchMode,
                      onRefresh: () => context.read<CoinListCubit>().refresh(),
                      child: _buildBody(context, state, localizations),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
