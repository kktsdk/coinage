import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/coin_icon.dart';
import 'package:coinage/utils/coin_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/coin.dart';

class CoinContent extends StatelessWidget {
  final Coin coin;

  const CoinContent({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final website = coin.websiteUrl;
    final description =
        (coin.description == null || coin.description!.trim().isEmpty)
        ? localizations.noDescription
        : coin.description!;
    final changeData = getChangeData(coin.change);
    final accentColor = parseHexColor(coin.color) ?? Colors.grey.shade400;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  CoinIcon(url: coin.iconUrl, size: 64),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.symbol,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
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
                                  fontSize: 16,
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
                    fontSize: 24,
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
                      style: TextStyle(fontSize: 16, color: changeData.color),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.marketCap,
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            const SizedBox(width: 8),
            Text(
              formatMarketCap(coin.marketCap?.toString()),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.description,
              style: const TextStyle(fontSize: 16, color: Colors.black45),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (website != null && website.isNotEmpty)
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text(localizations.goToWebsite),
              onPressed: () async {
                final uri = Uri.tryParse(website);
                if (uri == null) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.invalidWebsiteUrl)),
                  );
                  return;
                }

                try {
                  if (await canLaunchUrl(uri)) {
                    final launched = await launchUrl(uri);
                    if (!context.mounted) return;
                    if (!launched) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.couldNotOpenWebsite),
                        ),
                      );
                    }
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.couldNotOpenWebsite),
                      ),
                    );
                  }
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.couldNotOpenWebsite)),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
