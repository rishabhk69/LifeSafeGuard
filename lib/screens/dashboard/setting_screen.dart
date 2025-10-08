import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';

import '../../constants/app_utils.dart';
import '../../constants/base_appbar.dart';
import '../../constants/colors_constant.dart';
import '../../constants/strings.dart';

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
      appBar: BaseAppBar(title: StringHelper.setting,showAction: false,),
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
                  _buildListTile("Language", "English", true,(){
                    _showLanguageBottomSheet();
                  }),
                  _buildListTile(StringHelper.contactUs, "", true,(){
                    context.push('/contactUsScreen');
                  }),
                  _buildListTile(StringHelper.aboutUS, "", true,(){
                    context.push('/aboutUs');
                  }),
                  _buildListTile(StringHelper.donation, "", true,(){
                    context.push('/donateScreen');
                  }),
                  _buildListTile(StringHelper.reportAnIssue, "", true,(){
                    locator<ToastService> ().show('In Process');
                    // context.push('/reportIssueScreen');
                  }),
                  _buildListTile(StringHelper.feedback, "", true,(){}),
                  _buildListTile(StringHelper.deleteYourAccount, "", true,(){}),
                  _buildListTile(StringHelper.agreement, "", true,(){
                    context.push('/termsAndCondition');
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
                SvgPicture.asset(ImageHelper.fbIc),
                SizedBox(width: 30),
                SvgPicture.asset(ImageHelper.instaIc),
                SizedBox(width: 30),
                SvgPicture.asset(ImageHelper.twitterIc),
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
                      title: StringHelper.areYouSure,
                      subTitle: StringHelper.youWantToLogOut,
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
                child: const Text(
                  "Sign Out",
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
