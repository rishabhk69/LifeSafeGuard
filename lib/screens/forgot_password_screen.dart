import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/strings.dart';

import '../constants/custom_button.dart';
import '../constants/custom_text_field.dart';
import '../constants/logo_widget.dart';
import '../constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';

import 'package:untitled/localization/fitness_localization.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(hideBack: false, title: GuardLocalizations.of(context)!.translate("changePassword") ?? ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              CommonTextFieldWidget(
                maxLength: 10,
                keyboardType: TextInputType.phone,
                isPassword: false,
                hintText: GuardLocalizations.of(context)!.translate("phoneNumber") ?? "",
                textController: phoneController,
              ),
              CommonTextFieldWidget(
                maxLength: 20,
                isPassword: false,
                hintText: GuardLocalizations.of(context)!.translate("emailAddress") ?? "",
                textController: emailController,
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                // color: Colors.red,
                width: double.infinity,
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    GuardLocalizations.of(context)!.translate("hintQuestion") ?? "",
                    style: TextStyle(
                      color: Colors.black26,
                      // fontSize: 14,
                    ),
                  ),
                  items: items
                      .map(
                        (String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: ColorConstant.textFiledColor,
                              fontWeight: FontWeight.w500,
                              fontSize: textSize16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  underline: Container(
                    height: 1,
                    color: ColorConstant.primaryColor,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 60,
                    width: double.infinity,
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 40),
                ),
              ),

              CommonTextFieldWidget(
                maxLength: 20,
                isPassword: false,
                hintText: GuardLocalizations.of(context)!.translate("hintAnswer") ?? "",
                textController: answerController,
              ),
              addHeight(50.h),
              CustomButton(text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
