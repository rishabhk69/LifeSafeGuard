import 'package:flutter/material.dart';

import '../common/locator/locator.dart';
import '../constants/app_utils.dart';
import 'fitness_localization.dart';

const String LANGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String HINDI = 'hi';

final AppUtils _appUtils = locator<AppUtils>();

Future<Locale> setLocale(String languageCode) async {
  _appUtils.setLanguage(languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = await AppUtils().getSelectedLanguage();
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case ARABIC:
      return const Locale(ARABIC, "AE");
    case HINDI:
      return const Locale(HINDI, "IN");
    default:
      return const Locale(ENGLISH, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return GuardLocalizations.of(context)!.translate(key);
}