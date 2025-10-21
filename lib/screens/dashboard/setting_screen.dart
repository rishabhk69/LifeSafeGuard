import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_utils.dart';
import '../../constants/base_appbar.dart';
import '../../constants/colors_constant.dart';
import '../../constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';

import '../../main.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: GuardLocalizations.of(context)!.translate("setting") ?? "",showAction: false,),
      backgroundColor: ColorConstant.scaffoldColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffFBFBFB),
                borderRadius: BorderRadius.circular(5)
              ),
              margin: const EdgeInsets.all(12),

              child: ListView(
                children: [
                  _buildListTile(GuardLocalizations.of(context)!.translate("language") ?? "", "English", true,(){
                    _showLanguageBottomSheet();
                  }),
                  _buildListTile(GuardLocalizations.of(context)!.translate("contactUs") ?? "", "", true,(){
                    context.push('/contactUsScreen');
                  }),
                  _buildListTile(GuardLocalizations.of(context)!.translate("aboutUS") ?? "", "", true,(){
                    context.push('/aboutUs');
                  }),
                  _buildListTile(GuardLocalizations.of(context)!.translate("donation") ?? "", "", true,(){
                    context.push('/donateScreen');
                  }),
                  _buildListTile(GuardLocalizations.of(context)!.translate("reportAnIssue") ?? "", "", true,(){
                    locator<ToastService> ().show('In Process');
                    // context.push('/reportIssueScreen');
                  }),
                  _buildListTile(GuardLocalizations.of(context)!.translate("feedback") ?? "", "", true,(){}),
                  _buildListTile(GuardLocalizations.of(context)!.translate("deleteYourAccount") ?? "", "", true,(){}),
                  _buildListTile(GuardLocalizations.of(context)!.translate("agreement") ?? "", "", true,(){
                    context.push('/termsAndCondition',extra: {
                    'isLogin': 'false',
                    });
                  }),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "App Version - 1.2.9",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Social Icons
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                InkWell(
                    onTap: (){
                      launchUrl(Uri.parse('https://flutter.dev'));
                    },
                    child: SvgPicture.asset(ImageHelper.fbIc)),
                SizedBox(width: 30),
                InkWell(
                    onTap: (){
                      launchUrl(Uri.parse('https://flutter.dev'));
                    },
                    child: SvgPicture.asset(ImageHelper.instaIc)),
                SizedBox(width: 30),
                InkWell(
                    onTap: (){
                      launchUrl(Uri.parse('https://flutter.dev'));
                    },
                    child: SvgPicture.asset(ImageHelper.twitterIc)),
              ],
            ),
          ),
          addHeight(20),
          // Sign Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  locator<DialogService>().showLogoutDialog(
                      title: GuardLocalizations.of(context)!.translate("areYouSure") ?? "",
                      subTitle: GuardLocalizations.of(context)!.translate("youWantToLogOut") ?? "",
                      negativeButtonText: "No",
                      positiveButtonText: "Yes",
                      negativeTap: () {
                        context.pop();
                      },
                      positiveTap: () {
                        context.pop();
                        AppUtils().logoutUser().then((onValue){
                          context.go('/chooseLogin');
                        });
                      }
                  );

                },
                child: Text(
                  GuardLocalizations.of(context)!.translate("signOut") ?? "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, bool showArrow,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontSize: 16)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          Divider(thickness: 0.5,)
        ],
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
                  GuardLocalizations.of(context)!.translate("language") ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: Text("English"),
                  trailing: selectedLanguage == "English"
                      ? Icon(Icons.check, color: Colors.black)
                      : null,
                  onTap: () async {
                    await AppUtils().setLanguage('en');
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
                  onTap: () async {
                    await AppUtils().setLanguage('hi');
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
                      updateLang();
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

  updateLang() async {
    final currentLang = await AppUtils().getSelectedLanguage();
    if (currentLang == 'hi') {
      MyApp.setLocale(context, const Locale('hi', 'IN'));
      await AppUtils().setLanguage("hi");
    } else {
      MyApp.setLocale(context, const Locale("en", "US"));
      await AppUtils().setLanguage("en");
    }
  }

}
