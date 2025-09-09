import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';

import '../../constants/app_utils.dart';
import '../../constants/logo_widget.dart';
import '../../custom/app_progress_indicator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            (){
              if(isFirstTime){
                context.go('/dashboardScreen');
              }
              else{
                context.go('/login_screen');
              }
            });

  }

  getIsFirstTime(){
    AppUtils().getUserLoggedIn().then((onValue){
      if(onValue==true){
        setState(() {
          isFirstTime = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      body: Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            SizedBox(height: 20,),
            AppProgressIndicator()
          ],
        ),
      )),
    );
  }
}
