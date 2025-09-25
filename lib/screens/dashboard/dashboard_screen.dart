import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  int _currentIndex = 0;
  String? userId;
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
        print("userId:${userId}");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        body: _screens[_currentIndex],
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
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if(index==1){
               BlocProvider.of<IncidentsBloc>(context,listen: false).add(IncidentsRefreshEvent(10, 0));
              }
              else if(index==2){
               BlocProvider.of<ProfileBloc>(context,listen: false).add(ProfileRefreshEvent(10, 0,userId));
              }
            },
            items: [
              BottomNavigationBarItem(
                icon:SvgPicture.asset(_currentIndex ==0 ? ImageHelper.homeSelected:ImageHelper.homeUnselected),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex ==1 ? ImageHelper.videoSelect:ImageHelper.videoUnselect),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex ==2 ? ImageHelper.profileSelected:ImageHelper.profileUnselect),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(_currentIndex ==3 ? ImageHelper.settingSelected: ImageHelper.settingUnselected),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}