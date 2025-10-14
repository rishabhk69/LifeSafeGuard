import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/bloc/getIncident_bloc.dart';
import 'package:untitled/bloc/get_profile_bloc.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/screens/dashboard/profile_screen.dart';
import 'package:untitled/screens/dashboard/setting_screen.dart';
import 'package:untitled/screens/dashboard/video_screen.dart';

import '../../constants/base_appbar.dart';
import '../../constants/colors_constant.dart';
import '../../constants/strings.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userId;
  String? userName;
  final List<Widget> _screens = [
    HomeScreen(),
    VideoScreen(),
    ProfileScreen(),
    SettingScreen(),
  ];

  getUserId() async {
    await AppUtils().getUserId().then((onValue){
      setState(() {
        userId = onValue;
        BlocProvider.of<ProfileBloc>(context, listen: false).add(
            ProfileRefreshEvent(10, 0, userId));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(0));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context,dashboardState) {
          if (dashboardState is DashboardSuccessState) {
            return Scaffold(
              backgroundColor: ColorConstant.scaffoldColor,
              body: _screens[dashboardState.selectedIndex],
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, -2), // shadow above the nav bar
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  useLegacyColorScheme: true,
                  selectedItemColor: ColorConstant.primaryColor,
                  unselectedItemColor: ColorConstant.textColor,
                  backgroundColor: Colors.white,
                  currentIndex: dashboardState.selectedIndex,
                  onTap: (index) {
                    BlocProvider.of<DashboardBloc>(
                      context,
                    ).add(DashboardRefreshEvent(index));
                    if (index == 1) {
                      BlocProvider.of<IncidentsBloc>(context, listen: false)
                          .add(IncidentsRefreshEvent(10, 0));
                    }
                    else if (index == 2) {
                      BlocProvider.of<ProfileBloc>(context, listen: false).add(
                          ProfileRefreshEvent(10, 0, userId));
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(dashboardState.selectedIndex == 0
                          ? ImageHelper.homeSelected
                          : ImageHelper.homeUnselected),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(dashboardState.selectedIndex == 1
                          ? ImageHelper.videoSelect
                          : ImageHelper.videoUnselect),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(dashboardState.selectedIndex == 2
                          ? ImageHelper.profileSelected
                          : ImageHelper.profileUnselect),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(dashboardState.selectedIndex == 3
                          ? ImageHelper.settingSelected
                          : ImageHelper.settingUnselected),
                      label: '',
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        }
      ),
    );
  }
}