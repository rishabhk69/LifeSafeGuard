import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';
import '../../constants/base_appbar.dart';
import '../../constants/custom_text_field.dart';
import '../../constants/logo_widget.dart';
import 'package:untitled/localization/fitness_localization.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController loginController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(title: GuardLocalizations.of(context)!.translate("login") ?? "",hideBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              CommonTextFieldWidget(
                maxLength: 20,
                isPassword: false,
                hintText: GuardLocalizations.of(context)!.translate("userName") ?? "",
                textController: loginController,),
              CommonTextFieldWidget(
                maxLength: 20,
                isPassword: true,
                hintText: GuardLocalizations.of(context)!.translate("password") ?? "",
                textController: passwordController,),
              addHeight(50.h),
              CustomButton(text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: (){
                context.go('/usertype_screen');
              }),
              TextButton(onPressed: (){
                context.push('/signup');
              }, child: Text(GuardLocalizations.of(context)!.translate("register") ?? "")),
              TextButton(onPressed: (){
                context.push('/forgot_password');
              }, child: Text(GuardLocalizations.of(context)!.translate("forgotPassword") ?? ""))

            ],
          ),
        ),
      ),
    );
  }
}
