import 'package:coinage/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CoinLoadingIndicator extends StatelessWidget {
  const CoinLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          key: Key('CoinsBox'),
          color: Colors.red,
        ),
      ),
    );
  }
}

class CoinEmptyState extends StatelessWidget {
  const CoinEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          localizations.noResultsFound,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}

class CoinErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CoinErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }
}
