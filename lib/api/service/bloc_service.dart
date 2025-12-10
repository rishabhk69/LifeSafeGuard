import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled/api/repository/base/auth/main_repo.dart';
import 'package:untitled/bloc/auth/aggrement_bloc.dart';
import 'package:untitled/bloc/auth/delete_account_bloc.dart';
import 'package:untitled/bloc/blocked_list_bloc.dart';
import 'package:untitled/bloc/delete_incident_bloc.dart';
import 'package:untitled/bloc/edit_incidents_bloc.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/bloc/auth/otp_bloc.dart';
import 'package:untitled/bloc/auth/signup_bloc.dart';
import 'package:untitled/bloc/get_city_bloc.dart';
import 'package:untitled/bloc/get_comments_bloc.dart';
import 'package:untitled/bloc/get_incident_type_bloc.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/bloc/instruction_bloc.dart';
import 'package:untitled/bloc/post_comment_bloc.dart';
import 'package:untitled/bloc/post_incidents_bloc.dart';
import 'package:untitled/bloc/save_city_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/bloc/setting_bloc.dart';
import 'package:untitled/bloc/spam_incident_bloc.dart';
import 'package:untitled/bloc/support_bloc.dart';
import 'package:untitled/bloc/update_profile_bloc.dart';

import '../../bloc/auth/login_bloc.dart';
import '../../bloc/block_incident_bloc.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/file_selection_bloc.dart';
import '../../common/locator/locator.dart';
import '../../common/router/router.dart';
import '../../constants/colors_constant.dart';
import '../../localization/fitness_localization.dart';
import '../repository/base/auth/auth_repo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


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
          BlocProvider<BlockIncidentBloc>(
            create: (context) => BlockIncidentBloc(_mainRepository),
          ),
          BlocProvider<BlockedIncidentsBloc>(
            create: (context) => BlockedIncidentsBloc(_mainRepository),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(),
          ),
          BlocProvider<PostCommentBloc>(
            create: (context) => PostCommentBloc(_mainRepository),
          ),
          BlocProvider<SpamIncidentBloc>(
            create: (context) => SpamIncidentBloc(_mainRepository),
          ),
          BlocProvider<DeleteAccountBloc>(
            create: (context) => DeleteAccountBloc(_mainRepository),
          ),
          BlocProvider<CityListBloc>(
            create: (context) => CityListBloc(_mainRepository),
          ),
          BlocProvider<SaveCityBloc>(
            create: (context) => SaveCityBloc(_mainRepository),
          ),
          BlocProvider<IncidentTypeBloc>(
            create: (context) => IncidentTypeBloc(_mainRepository),
          ),
          BlocProvider<SupportHelpBloc>(
            create: (context) => SupportHelpBloc(_mainRepository),
          ),
          BlocProvider<UpdateProfileBloc>(
            create: (context) => UpdateProfileBloc(_mainRepository),
          ),
          BlocProvider<SettingBloc>(
            create: (context) => SettingBloc(_mainRepository),
          ),
          BlocProvider<DeleteIncidentBloc>(
            create: (context) => DeleteIncidentBloc(_mainRepository),
          ),
          BlocProvider<InstructionBloc>(
            create: (context) => InstructionBloc(_mainRepository),
          ),
          BlocProvider<EditIncidentsBloc>(
            create: (context) => EditIncidentsBloc(_mainRepository),
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

                routerConfig: goRouter,
                title: 'Life Safe Guard',
                debugShowCheckedModeBanner: false,
                locale: _locale,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('hi', 'IN'),
                ],
                localizationsDelegates: [
                  GuardLocalizations.delegate,
                  ...GlobalMaterialLocalizations.delegates,
                ],
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
