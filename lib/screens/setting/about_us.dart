import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/image_helper.dart';

import '../../constants/colors_constant.dart';
import '../../constants/strings.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            StringHelper.aboutUS,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body:  SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration
              Center(
                child: SvgPicture.asset(
                  ImageHelper.aboutUsIc,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),

              // Title
               Text(
                "Life Safe Guard",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Description
               Text(
                "Lorem ipsum dolor sit amet consectetur. "
                    "Nisi id consectetur aliquam quam varius cursus scelerisque. "
                    "Nunc mattis ullamcorper aliquet eget iaculis nunc dignissim suspendisse. "
                    "Facilisis elementum etiam et ut. Nulla feugiat fringilla blandit ut ut "
                    "adipiscing malesuada vulputate.\n\n"
                    "Lorem ipsum dolor sit amet consectetur. "
                    "Nisi id consectetur aliquam quam varius cursus scelerisque. "
                    "Nunc mattis ullamcorper aliquet eget iaculis nunc dignissim suspendisse. "
                    "Facilisis elementum etiam et ut. Nulla feugiat fringilla blandit ut ut "
                    "adipiscing malesuada vulputate.",
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
      );
  }
}
