import 'package:flutter/material.dart';

import '../../constants/colors_constant.dart';

class AppThemes {
  static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      primaryColor: ColorConstant.primaryColor,
      // ignore: deprecated_member_use
      // accentColor: ColorConstant.accentColor,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      }),
      // ignore: deprecated_member_use
      // backgroundColor: colorBgLight,
      // scaffoldBackgroundColor: colorBgLight,
      highlightColor: Colors.black,
      fontFamily: "Montserrat",
      // ignore: deprecated_member_use
      cardColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
        displayLarge: TextStyle(
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
    AppTheme.darkTheme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      primaryColor: ColorConstant.primaryColor,
      scrollbarTheme: ScrollbarThemeData(
        // isAlwaysShown: true,
        interactive: true,
        // showTrackOnHover: true,
        thumbColor: MaterialStateProperty.all(Colors.grey),
      ),
      primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
        ),
        displayLarge: TextStyle(
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
        ),
      ),
      // primaryColorLight: colorBlack,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: const Color(0xFF212121),
      // dialogBackgroundColor: colorGreenDark,
      // ignore: deprecated_member_use
      // textSelectionColor: colorTextGrey,
      highlightColor: Colors.grey.shade300,
      cardColor: const Color(0xFF424242),
      iconTheme: const IconThemeData(color: Colors.white),
      // disabledColor: colorWhite,
      // bottomAppBarColor: pageBg,
      // ignore: deprecated_member_use
      // textSelectionHandleColor: colorText,
      // secondaryHeaderColor: colorTextDark,
      // ignore: deprecated_member_use
      // cursorColor: colorTextDarkBlue,
      // ignore: deprecated_member_use
      // buttonColor: colorTextOrange,
      // focusColor: colorRed,
      fontFamily: "Montserrat",
      // indicatorColor: themeLightGrey
    ),
  };
}

enum AppTheme {
  lightTheme,
  darkTheme,
}
