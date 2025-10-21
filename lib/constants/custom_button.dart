import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors_constant.dart';

class CustomButton extends StatelessWidget {
  double? buttonWidth;
  void Function()? onTap;
  double? buttonHeight;
  Color buttonColor;
  Color? textColor;
  double? horizontal;
  bool? isEnable;
  String? text;
  CustomButton(
      {Key? key,
      this.horizontal,
      this.isEnable = true,
        required this.text,
      this.buttonHeight = 40,
      this.buttonWidth,
      this.textColor = ColorConstant.whiteColor,
      required this.onTap,
      // required this.text,
      this.buttonColor = ColorConstant.primaryColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable==true?onTap: null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: buttonHeight?.h,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isEnable==true? buttonColor : ColorConstant.blackLightColor.withOpacity(0.30), borderRadius: BorderRadius.circular(25)),
        child: Text(
          // GuardLocalizations.of(context)!.translate("save") ?? "",
          text!,
          style: GoogleFonts.poppins(
            color: ColorConstant.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}
