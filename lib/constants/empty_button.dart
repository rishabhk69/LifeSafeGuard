import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_constant.dart';

class EmptyButton extends StatelessWidget {
  String? title;
  double?padding;
  Color? color;
  void Function()? onTap;
  EmptyButton({Key? key,this.title,this.padding,this.color,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding??50.w),
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorConstant.cancleBtnColor.withOpacity(0.6), borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: color??ColorConstant.primaryColor,
              width: 2.w
          ),
        ),
        child:  Text(
          title??"",
          // text,
          style: TextStyle(
            color: color??ColorConstant.primaryColor,
            fontSize: 15.sp,
            // fontFamily: FontFamilyConstants.markPro,
          ),
        ),
      ),
    );
  }
}
