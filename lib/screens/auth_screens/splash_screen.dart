import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';

import '../../constants/logo_widget.dart';
import '../../custom/app_progress_indicator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            (){
          context.go('/login_screen');
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
