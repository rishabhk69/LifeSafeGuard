import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_helper.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Image.asset(ImageHelper.logoLion),
          Image.asset(ImageHelper.appLogo),
        ],
      ),
    );
  }
}
