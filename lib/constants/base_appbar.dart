import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/sizes.dart';

import '../common/locator/locator.dart';
import '../common/service/navigation_service.dart';
import 'app_styles.dart';
import 'colors_constant.dart';
import 'image_helper.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.white;
  final String? title;
  final bool? hideBack;
  final bool? isMainBar;
  final bool? isVideo;
  final bool? showAction;
  final List<Widget>? widgets;
  final void Function()? onTap;
  final Function()? onActionTap;

  /// you can add more fields that meet your needs

  const  BaseAppBar({super.key, this.title,this.isVideo, this.widgets, this.hideBack,this.isMainBar,this.showAction,this.onTap,this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: isMainBar??false ? Container(
        color: ColorConstant.whiteColor,
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal:textSize16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.keyboard_backspace),
            Row(
              children: [
                Text(title ?? '',
                    style:
                    MyTextStyleBase.headingStyle.copyWith(color:ColorConstant.blackColor)),
                if((widgets??[]).isNotEmpty)
                widgets![0]
              ],
            ),
            showAction??false ? InkWell(
                onTap: onTap,
                child: Icon(Icons.menu)) :SizedBox()
          ],
        ),
      ): Container(
        alignment: Alignment.center,
        color: ColorConstant.whiteColor,
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal:textSize16),
        child: showAction??false ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(title ?? '',
                style:
                MyTextStyleBase.headingStyle.copyWith(color:ColorConstant.blackColor)),
            InkWell(
              onTap: onActionTap,
                child: isVideo??false ?SvgPicture.asset(ImageHelper.photoIc) :
                Icon(Icons.video_call_outlined,color: ColorConstant.primaryColor,size: 35,))
          ],
        ):Text(title ?? '',
            style:
            MyTextStyleBase.headingStyle.copyWith(color:ColorConstant.blackColor)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
