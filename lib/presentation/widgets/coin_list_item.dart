import 'package:coinage/data/models/coin.dart';
import 'package:coinage/presentation/widgets/coin_icon.dart';
import 'package:coinage/utils/coin_utils.dart';
import 'package:flutter/material.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final int index;
  final VoidCallback onTap;

  const CoinListItem({
    super.key,
    required this.coin,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final changeData = getChangeData(coin.change);
    final accentColor = parseHexColor(coin.color) ?? Colors.grey.shade400;

    return InkWell(
      onTap: onTap,
      child: Container(
        key: Key('coin-item-$index'),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CoinIcon(url: coin.iconUrl, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.symbol,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    coin.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${(double.tryParse(coin.price ?? '0') ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          changeData.isNegative
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: changeData.color,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          changeData.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: changeData.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFe5e7eb)),
          ],
        ),
      ),
    );
  }
}
