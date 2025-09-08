import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FitnessLocalizations {
  FitnessLocalizations(this.locale);

  final Locale locale;
  static FitnessLocalizations? of(BuildContext context) {
    return Localizations.of<FitnessLocalizations>(context, FitnessLocalizations);
  }

    Map<String, String>? _localizedValues;

  Future<void> load() async {
    String jsonStringValues =
        await rootBundle.loadString('lib/languages/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedValues![key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<FitnessLocalizations> delegate = _FitnessLocalizationssDelegate();
}

class _FitnessLocalizationssDelegate
    extends LocalizationsDelegate<FitnessLocalizations> {
  const _FitnessLocalizationssDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<FitnessLocalizations> load(Locale locale) async {
    FitnessLocalizations localization = FitnessLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<FitnessLocalizations> old) => false;
}