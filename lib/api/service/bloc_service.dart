import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:demoSetup/api/repository/base/auth/main_repo.dart';
// import 'package:demoSetup/bloc/auth/increment_bloc.dart';
// import 'package:demoSetup/bloc/upload_licence.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled/api/repository/base/auth/main_repo.dart';
import 'package:untitled/bloc/auth/aggrement_bloc.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/bloc/auth/otp_bloc.dart';
import 'package:untitled/bloc/auth/signup_bloc.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/bloc/post_incidents_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';

import '../../bloc/auth/login_bloc.dart';
import '../../bloc/file_selection_bloc.dart';
import '../../common/locator/locator.dart';
import '../../common/router/router.dart';
import '../../constants/colors_constant.dart';
import '../../localization/fitness_localization.dart';
import '../repository/base/auth/auth_repo.dart';

class BlocServices {
  BlocServices(this._locale);
  final Locale _locale;

  final AuthRepository _authRepository = locator<AuthRepository>();
  final MainRepository _mainRepository = locator<MainRepository>();

  blocService() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<FileSelectionBloc>(create: (context) => FileSelectionBloc()),
          // BlocProvider<UploadLicenceBloc>(
          //     create: (context) => UploadLicenceBloc()),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(_mainRepository),
          ),
          BlocProvider<OtpBloc>(
            create: (context) => OtpBloc(_mainRepository),
          ),
          BlocProvider<AgreementBloc>(
            create: (context) => AgreementBloc(_mainRepository),
          ),
          BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(_mainRepository),
          ),
          BlocProvider<IncidentsBloc>(
            create: (context) => IncidentsBloc(_mainRepository),
          ),
          BlocProvider<PostIncidentsBloc>(
            create: (context) => PostIncidentsBloc(_mainRepository),
          ),
          BlocProvider<SetIncidentsBloc>(
            create: (context) => SetIncidentsBloc(),
          ),
          BlocProvider<CommentsBloc>(
            create: (context) => CommentsBloc(_mainRepository),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(_mainRepository),
          ),
          // BlocProvider<UserProfileBloc>(
          //   create: (context) => UserProfileBloc(_mainRepository),
          // ),

        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MaterialApp.router(
                localizationsDelegates: [
                  FitnessLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                routerConfig: goRouter,
                title: 'LifeSafeGuard',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                        color: ColorConstant.whiteColor
                    ),
                    iconTheme: IconThemeData(
                        color: ColorConstant.whiteColor
                    ),),
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                ),
                // home: const SplashScreen(),
              )
            );
          },
        ));
  }
}
