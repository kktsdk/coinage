class Coin {
  final String uuid;
  final String symbol;
  final String name;
  final String? color;
  final String iconUrl;
  final String? marketCap;
  final String? description;
  final String? websiteUrl;
  final String? price;
  final int? listedAt;
  final int? tier;
  final String? change;
  final int rank;
  final List<String> sparkline;
  final AllTimeHigh? allTimeHigh;
  final bool lowVolume;
  final String? coinrankingUrl;
  final String? volume24h;
  final String? btcPrice;
  final List<String> contractAddresses;
  final bool isWrappedTrustless;
  final String? wrappedTo;
  final String? coinGeckoId;
  final String? coinMarketCapId;


  Coin({
    required this.uuid,
    required this.symbol,
    required this.name,
    this.color,
    required this.iconUrl,
    this.marketCap,
    this.description,
    this.websiteUrl,
    this.price,
    this.listedAt,
    this.tier,
    this.change,
    required this.rank,
    required this.sparkline,
    this.allTimeHigh,
    this.lowVolume = false,
    this.coinrankingUrl,
    this.volume24h,
    this.btcPrice,
    required this.contractAddresses,
    this.isWrappedTrustless = false,
    this.wrappedTo,
    this.coinGeckoId,
    this.coinMarketCapId,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        uuid: json['uuid'] as String,
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        color: json['color'] as String?,
        iconUrl: json['iconUrl'] as String? ?? '',
        marketCap: json['marketCap'] as String?,
        description: json['description'] as String?,
        websiteUrl: json['websiteUrl'] as String?,
        price: json['price'] as String?,
        listedAt: json['listedAt'] as int?,
        tier: json['tier'] as int?,
        change: json['change'] as String?,
        rank: json['rank'] as int? ?? 0,
        sparkline: (json['sparkline'] as List<dynamic>?)
                ?.map((e) => e != null ? e as String : '0')
                .toList() ??
            [],
        allTimeHigh: json['allTimeHigh'] != null
            ? AllTimeHigh.fromJson(json['allTimeHigh'] as Map<String, dynamic>)
            : null,
        lowVolume: json['lowVolume'] as bool? ?? false,
        coinrankingUrl: json['coinrankingUrl'] as String?,
        volume24h: json['24hVolume'] as String?,
        btcPrice: json['btcPrice'] as String?,
        contractAddresses: (json['contractAddresses'] as List<dynamic>?)
                ?.map((e) => e != null ? e as String : '')
                .toList() ??
            [],
        isWrappedTrustless: json['isWrappedTrustless'] as bool? ?? false,
        wrappedTo: json['wrappedTo'] as String?,
        coinGeckoId: json['coinGeckoId'] as String?,
        coinMarketCapId: json['coinMarketCapId'] as String?,
      );
}

class AllTimeHigh {
  final String price;
  final int timestamp;

  AllTimeHigh({
    required this.price,
    required this.timestamp,
  });

  factory AllTimeHigh.fromJson(Map<String, dynamic> json) => AllTimeHigh(
        price: json['price'] as String? ?? '',
        timestamp: json['timestamp'] as int? ?? 0,
      );
}
