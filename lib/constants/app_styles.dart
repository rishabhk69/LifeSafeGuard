import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors_constant.dart';


class MyTextStyleBase {
  static var headingStyle = GoogleFonts.poppins(
    fontSize: 20,
    color: ColorConstant.blackColor,
    fontWeight: FontWeight.w500
  );
  static var headingStyleLight = GoogleFonts.jost(
    fontSize: 16,
    color: ColorConstant.blackLightColor,
    fontWeight: FontWeight.w600
  );
  static var headingStyleSemi = GoogleFonts.jost(
    fontSize: 14,
    color: ColorConstant.blackLightColor,
    fontWeight: FontWeight.w600
  );
  static var size_B = GoogleFonts.pacifico(fontSize: 30);
}