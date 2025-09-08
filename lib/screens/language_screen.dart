import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        appBar: BaseAppBar(title: StringHelper.selectLanguage),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageHelper.language_frame),
              addHeight(20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                child: InkWell(
                  onTap: (){
                    _showLanguageBottomSheet();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageHelper.languageCircle),
                      addWidth(5),
                      Text(StringHelper.language,style: GoogleFonts.poppins(
                        color: ColorConstant.blackColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),),
                      Spacer(),
                      Text(StringHelper.english,style: GoogleFonts.poppins(
                          color: Color(0xff191919),
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                child: CustomButton(text: StringHelper.done, onTap: (){
                  context.push('/onboardingScreen');
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: ColorConstant.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Language",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: Text("English"),
                  trailing: selectedLanguage == "English"
                      ? Icon(Icons.check, color: Colors.black)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = "English";
                    });
                    Navigator.pop(context);
                    _showLanguageBottomSheet();
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("हिंदी"),
                  trailing: selectedLanguage == "हिंदी"
                      ? Icon(Icons.check, color: Colors.black)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = "हिंदी";
                    });
                    Navigator.pop(context);
                    _showLanguageBottomSheet();
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

}

