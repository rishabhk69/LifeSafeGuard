import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/auth/login_bloc.dart';
import 'package:untitled/bloc/auth/otp_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/common_background.dart';
import 'package:untitled/constants/image_helper.dart';

import '../constants/colors_constant.dart';
import '../constants/custom_button.dart';
import '../constants/sizes.dart';
import '../constants/strings.dart';

class OtpScreen extends StatefulWidget {

  String phone;
  String otp;


  OtpScreen(this.phone,this.otp);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  String? otpCode;
  @override
  Widget build(BuildContext context) {
    print(widget.phone);
    return CommonBackground(
      iconName: ImageHelper.mobileIc,
      child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              StringHelper.verificationCode,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              StringHelper.pleaseEnterCodeSentToYourNumber,
              style: GoogleFonts.poppins(fontSize: 17, color: ColorConstant.blackColor,fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),

            addHeight(20),
            OtpTextField(
              numberOfFields: 6,
              borderColor: ColorConstant.primaryColor,
              focusedBorderColor: ColorConstant.primaryColor,
              showFieldAsBox: false,
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 20
              ),
              //runs when a code is typed in
              onCodeChanged: (String code) {
                setState(() {
                  otpCode = code;
                });
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                otpCode = verificationCode;
              }, // end onSubmit
            ),
            addHeight(20),
            BlocListener<LoginBloc,LoginState>(
              listener: (context,loginState){
                if(loginState is LoginLoadingState){
                  locator<DialogService>().showLoader();
                }
                else if(loginState is LoginSuccessState){
                  locator<DialogService>().hideLoader();
                  context.pop();
                  locator<ToastService>().show(loginState.loginData.message??"");
                }
                else if(loginState is LoginErrorState){
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(loginState.errorMsg??"");
                }
              },child: InkWell(
                onTap: (){
                  BlocProvider.of<LoginBloc>(context,listen: false).add(LoginRefreshEvent(widget.phone,false));
                },
                child: Text('Resend'))),

          ],
        ),
        BlocListener<OtpBloc,OtpState>(
          listener: (context,loginState){
            if(loginState is OtpLoadingState){
              locator<DialogService>().showLoader();
            }
            else if(loginState is OtpSuccessState){
              locator<DialogService>().hideLoader();
              context.pop();
              locator<ToastService>().show(loginState.otpData.message??"");
              AppUtils().setToken(loginState.otpData.token??"");
              context.push('/termsAndCondition');
            }
            else if(loginState is OtpErrorState){
              locator<DialogService>().hideLoader();
              locator<ToastService>().show(loginState.errorMsg??"");
            }
          },child: CustomButton(
            buttonHeight: 50,
            text: StringHelper.verify, onTap: (){
          // context.push('/termsAndCondition');
        if((otpCode?.length)==6){
          BlocProvider.of<OtpBloc>(context).add(OtpRefreshEvent(otp: otpCode,phoneNumber: widget.phone));
        }
        else{
          locator<ToastService>().show('Invalid');
        }
        }),),

        SizedBox(),
      ],
    ),);
  }
}
