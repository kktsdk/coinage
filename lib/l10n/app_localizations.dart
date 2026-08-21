import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations();

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get searchCoins => 'Search coins';
  String get inviteFriends => 'Invite Friends';
  String get noResultsFound => 'No results found';
  String get retry => 'Retry';
  String get noDescription => 'No description';
  String get goToWebsite => 'Go to Website';
  String get topCoinsTitle => 'Top 3 Coins';
  String get coinsSectionTitle => 'Coins';
  String get coinDetailsTitle => 'Coin Details';
  String get somethingWentWrong => 'Something went wrong';
  String get invalidWebsiteUrl => 'Invalid website URL';
  String get couldNotOpenWebsite => 'Could not open the website';
  String get marketCap => 'Market Cap';
  String get description => 'Description';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(const AppLocalizations());
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
