import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/common_background.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';


class ChooseLogin extends StatefulWidget {
  const ChooseLogin({super.key});

  @override
  State<ChooseLogin> createState() => _ChooseLoginState();
}

class _ChooseLoginState extends State<ChooseLogin> {
  @override
  Widget build(BuildContext context) {
    return CommonBackground(
        iconName: ImageHelper.startHereIc,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
           Column(
             children: [
               CustomButton(
                   buttonHeight: 50,
                   text: GuardLocalizations.of(context)!.translate("login") ?? "", onTap: (){
                 context.go('/mobileScreen',extra: {
                   'isLogin': 'true',
                 });
               }),
               Row(
                 children: [
                   Expanded(child: Divider()),
                   Text('Or'),
                   Expanded(child: Divider()),
                 ],
               ),
               CustomButton(
                   buttonHeight: 50,
                   text: GuardLocalizations.of(context)!.translate("signUP") ?? "", onTap: (){
                 context.go('/mobileScreen',extra: {
                   'isLogin': 'false',
                 });
               }),
             ],
           ),
            SizedBox(),
            SizedBox(),
          ],
        ));
  }
}
