import 'package:coinage/l10n/app_localizations.dart';
import 'package:coinage/presentation/widgets/coin_content.dart';
import 'package:coinage/presentation/widgets/coin_state_widgets.dart';
import 'package:flutter/material.dart';

import '../../data/models/coin.dart';
import '../../data/repositories/coin_repository.dart';
import '../../data/repositories/coin_repository_impl.dart';

class CoinDetail extends StatefulWidget {
  final String coinId;
  final CoinRepository? repository;

  const CoinDetail({super.key, required this.coinId, this.repository});

  @override
  CoinDetailState createState() => CoinDetailState();
}

class CoinDetailState extends State<CoinDetail> {
  late final CoinRepository _repository =
      widget.repository ?? const CoinRepositoryImpl();
  late Future<Coin> coinDetail;

  @override
  void initState() {
    super.initState();
    coinDetail = _repository.getCoinById(widget.coinId);
  }

  void _retryCoinDetail() {
    setState(() {
      coinDetail = _repository.getCoinById(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.coinDetailsTitle,
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          scrollDirection: Axis.vertical,
          child: FutureBuilder<Coin>(
            future: coinDetail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(
                      key: Key('CoinDetailContentBox'),
                      color: Colors.orange,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return CoinErrorState(
                  message: snapshot.error.toString(),
                  onRetry: _retryCoinDetail,
                );
              }

              return CoinContent(coin: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

