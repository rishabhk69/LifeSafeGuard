import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'api/service/bloc_service.dart';
import 'common/locator/locator.dart';
import 'common/router/router.dart';
import 'constants/app_utils.dart';
import 'constants/colors_constant.dart';
import 'package:flutter_localization/flutter_localization.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  currentDate = formatter.format(now);
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MyApp();
      },
    ),
  );
  // runApp(const MyApp());
  await setupLocator();

}

final rootNavigatorKey = GlobalKey<NavigatorState>();

String? currentDate;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  Locale _locale = const Locale("en", "US");

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // checkDevMode();
    setInitialLang();
  }


  setInitialLang() async {
    await AppUtils().setLanguage('en');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // return MaterialApp.router(
    //   localizationsDelegates: [
    //     CountryLocalizations.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //   ],
    //   routerConfig: goRouter,
    //   title: 'LifeSafeGuard',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     appBarTheme: const AppBarTheme(
    //       titleTextStyle: TextStyle(
    //           color: ColorConstant.whiteColor
    //       ),
    //       iconTheme: IconThemeData(
    //           color: ColorConstant.whiteColor// 👈 back button color
    //       ),),
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   // home: const SplashScreen(),
    // );
    return BlocServices(_locale).blocService();
  }
}

class NavigationServiceKey {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}
