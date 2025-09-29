import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/image_helper.dart';
import '../constants/colors_constant.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  bool isFirstTime = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getIsLogin();
    getIsFirstTime();
    Timer(
        Duration(seconds: 3),
            (){
          if(isFirstTime){
            context.go('/languageScreen');
          }
          else{
            if(isLoggedIn){
              context.go('/dashboardScreen');
            }
            else{
            context.go('/chooseLogin');
            }
          }

        });

  }

  getIsFirstTime(){
    AppUtils().getRemember().then((onValue){
      if(onValue==true){
        setState(() {
          isFirstTime = false;
        });
      }
    });
  }

  getIsLogin(){
    AppUtils().getUserLoggedIn().then((onValue){
        setState(() {
          isLoggedIn = onValue;
        });

    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      body: Center(child: Image.asset(ImageHelper.img_splash
      )),
    );
  }
}
