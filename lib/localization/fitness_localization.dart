import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuardLocalizations {
  GuardLocalizations(this.locale);

  final Locale locale;
  static GuardLocalizations? of(BuildContext context) {
    return Localizations.of<GuardLocalizations>(context, GuardLocalizations);
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
  static const LocalizationsDelegate<GuardLocalizations> delegate = _GuardLocalizationssDelegate();
}

class _GuardLocalizationssDelegate
    extends LocalizationsDelegate<GuardLocalizations> {
  const _GuardLocalizationssDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<GuardLocalizations> load(Locale locale) async {
    GuardLocalizations localization = GuardLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<GuardLocalizations> old) => false;
}