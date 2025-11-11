import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/screens/auth_screens/choose_login.dart';
import 'package:untitled/screens/auth_screens/sign_up.dart';
import 'package:untitled/screens/mobile_screen.dart';
import 'package:untitled/screens/other_screens/blocked_incidents.dart';
import 'package:untitled/screens/other_screens/filter_screen.dart';
import 'package:untitled/screens/other_screens/incident_details.dart';
import 'package:untitled/screens/other_screens/incident_type_screen.dart';
import 'package:untitled/screens/other_screens/select_city.dart';
import 'package:untitled/screens/other_screens/t&c_screen.dart';
import 'package:untitled/screens/other_screens/take_action.dart';
import 'package:untitled/screens/setting/block_incident_screen.dart';
import 'package:untitled/screens/setting/spam_screen.dart';

import '../../main.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/language_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/opt_screen.dart';
import '../../screens/setting/about_us.dart';
import '../../screens/setting/contact_us_screen.dart';
import '../../screens/setting/donate_screen.dart';
import '../../screens/setting/report_issue_screen.dart';
import '../../screens/splash_screen.dart';



final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: NavigationServiceKey.navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/languageScreen',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/onboardingScreen',
      builder: (context, state) =>  OnboardingScreen(),
    ),
    GoRoute(
      path: '/mobileScreen',
      builder: (context, state) {
        dynamic args = state.extra;
        return MobileScreen(args['isLogin'].toString());
      },
    ),
    GoRoute(
      path: '/otpScreen',
      builder: (context, state) {
        dynamic args = state.extra;
        return OtpScreen(
            args['phone'].toString(),args['otp'].toString(),args['isLogin'].toString(),);
      },
    ),
    GoRoute(
      path: '/dashboardScreen',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/reportIssueScreen',
      builder: (context, state) {
      dynamic args = state.extra;
      return ReportIssueScreen(args['isReport'].toString());
    }),

    GoRoute(
      path: '/blockIncidentScreen',
      builder: (context, state) {
        dynamic incidentData = state.extra as IncidentsModel;
        return BlockIncidentScreen(incidentData);
    }),

    GoRoute(
      path: '/spamScreen',
      builder: (context, state) {
    dynamic incidentData = state.extra as IncidentsModel;
    return SpamScreen(incidentData);
    }
    ),
    GoRoute(
      path: '/contactUsScreen',
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: '/aboutUs',
      builder: (context, state) => const AboutUs(),
    ),
    GoRoute(
      path: '/donateScreen',
      builder: (context, state) => const DonateScreen(),
    ),
    GoRoute(
      path: '/blockedIncidents',
      builder: (context, state) => const BlockedIncidents(),
    ),
    GoRoute(
      path: '/incidentDetails',
      builder: (context, state) {
        dynamic incidentData = state.extra as IncidentsModel;
        return IncidentDetails(
            incidentData
        );
      }
    ),
    GoRoute(
      path: '/filterScreen',
      builder: (context, state) => const FilterScreen(),
    ),
    GoRoute(
      path: '/selectCity',
      builder: (context, state) => const SelectCity(),
    ),
    GoRoute(
      path: '/incidentTypeScreen',
      builder: (context, state) => const IncidentTypeScreen(),
    ),
    GoRoute(
      path: '/takeAction',
      builder: (context, state){
        dynamic incidentData = state.extra as IncidentsModel;
        return TakeAction(incidentData);
      },
    ),
    GoRoute(
      path: '/signupScreen',
      builder: (context, state) {
        dynamic args = state.extra;
        return  SignupScreen(args['isEdit'].toString());
      },
    ),
    GoRoute(
      path: '/termsAndCondition',
      builder: (context, state) {
        dynamic args = state.extra;
        return  TermsAndCondition(args['isLogin'].toString());
      },
    ),
    GoRoute(
      path: '/chooseLogin',
      builder: (context, state) => const ChooseLogin(),
    ),
  ],
);

