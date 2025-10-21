import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;


  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> onboardingData = [
      {
        "image": "assets/images/onboarding1.png",
        "title": GuardLocalizations.of(context)!.translate("title1") ?? "",
        "desc": GuardLocalizations.of(context)!.translate("des1") ?? ""
      },
      {
        "image": "assets/images/onboarding2.png",
        "title": GuardLocalizations.of(context)!.translate("title2") ?? "",
        "desc": GuardLocalizations.of(context)!.translate("des2") ?? ""
      },
      {
        "image": "assets/images/onboarding3.png",
        "title": GuardLocalizations.of(context)!.translate("title3") ?? "",
        "desc": GuardLocalizations.of(context)!.translate("des3") ?? ""
      },
    ];
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == onboardingData.length - 1);
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(onboardingData[index]["image"]!),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          onboardingData[index]["title"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          onboardingData[index]["desc"]!,
                          style: GoogleFonts.poppins(fontSize: 14, color: ColorConstant.blackColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              child: isLastPage
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: CustomButton(
                    buttonHeight: 50,
                    text: GuardLocalizations.of(context)!.translate("getStarted") ?? "", onTap: (){
                      AppUtils().setRemember(true);
                      context.go('/chooseLogin');
                }),
              )
                  : Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: onboardingData.length,
                      effect: WormEffect(
                        dotColor: Colors.grey.shade300,
                        activeDotColor: Colors.orange,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, size: 28),
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
