import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';

import '../../constants/logo_widget.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(
        title: StringHelper.welcomeUser,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoWidget(),
            addHeight(50.h),
            TextButton(onPressed: (){}, child: Text('i.	New Registration / License')),
            TextButton(onPressed: (){}, child: Text('ii.	Renewal')),
            TextButton(onPressed: (){}, child: Text('iii.	Amendment')),
            TextButton(onPressed: (){}, child: Text('iv.	Payment')),
            CustomButton(text: StringHelper.submit, onTap: (){
              context.push('/select_act');
            }),
          ],
        ),
      ),
    );
  }
}
