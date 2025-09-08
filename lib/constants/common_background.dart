import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';

class CommonBackground extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBack;
  final dynamic iconName;
  final Function()? onTap;

  const CommonBackground({
    super.key,
    required this.child,
    this.title,
    this.iconName,
    this.onTap,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.35,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(ImageHelper.bgImage),fit: BoxFit.fill),
                  // color: ColorConstant.primaryColor,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(60),
                  //   bottomRight: Radius.circular(60),
                  // ),
                ),
              ),

              // White content area
              Positioned(
                top: size.height * 0.20,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height,
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: child,
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: 100,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 140,
                      width: 140,
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.primaryColor),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: SizedBox(
                      height: 50,
                      width: 50,
                        child:iconName.contains('svg')  ? SvgPicture.asset(iconName??""):
                        Image.file(File(iconName.path)),
                      ),
                    ),
                  ),
                ),
              ),
              if(showBack)
              Positioned(
                left: 0,
                right: 0,
                top: 15,
                child: InkWell(
                  onTap: (){
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.keyboard_backspace_outlined,color: ColorConstant.whiteColor,),
                        Text(title??"",style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: ColorConstant.whiteColor,
                          fontWeight: FontWeight.w500
                        ),),
                        SizedBox()
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
