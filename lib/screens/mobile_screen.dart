import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/auth/login_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/common_background.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';

import '../common/Utils/validations.dart';
import '../constants/custom_button.dart';
import '../constants/strings.dart';

class MobileScreen extends StatefulWidget {
  dynamic isLogin;


  MobileScreen(this.isLogin);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {


  TextEditingController mobileController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String selectedPhoneCode = "+91";

  @override
  Widget build(BuildContext context) {
    print("isLogin:${widget.isLogin}");
    return CommonBackground(
        iconName: ImageHelper.mobileIc,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Form(
          key: formGlobalKey,
          child: Column(
            children: [
              Text(
                StringHelper.verifyYourPhoneNumber,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                StringHelper.pleaseEnterYourPhoneNumber,
                style: GoogleFonts.poppins(fontSize: 14, color: ColorConstant.blackColor,fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),

              addHeight(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CountryCodePicker(
                    flagWidth: 20,
                    textStyle: TextStyle(fontSize: 10),
                    initialSelection: 'IN',
                    favorite: ['+91','IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    enabled: true,
                    showFlag: true,
                    showFlagMain: true,
                    onChanged: (countryCode) {
                      setState(() {
                        selectedPhoneCode = countryCode.dialCode??"";
                      });
                    },
                  ),
                  addWidth(5),
                  Expanded(child: CommonTextFieldWidget(
                      validator: (v){
                        return Validations.phoneValidation(v,StringHelper.mobileNo);
                      },
                      isPassword: false,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      hintText: StringHelper.mobileNo,
                      textController: mobileController)),
                ],
              ),
            ],
          ),
        ),

        BlocListener<LoginBloc,LoginState>(
          listener: (context,loginState){
            if(loginState is LoginLoadingState){
              locator<DialogService>().showLoader();
            }
            else if(loginState is LoginSuccessState){
              locator<DialogService>().hideLoader();
              locator<ToastService>().show(loginState.loginData.message??"");
              context.push('/otpScreen',extra: {
                'phone': selectedPhoneCode+mobileController.text.trim(),
                'otp': loginState.loginData.otp
              });
            }
            else if(loginState is LoginErrorState){
              locator<DialogService>().hideLoader();
              locator<ToastService>().show(loginState.errorMsg??"");
            }
          },child:  CustomButton(
            buttonHeight: 50,
            text: StringHelper.send, onTap: (){
          if(formGlobalKey.currentState!.validate()){
            // context.go('/dashboardScreen');
            BlocProvider.of<LoginBloc>(context,listen: false).add(LoginRefreshEvent(
                selectedPhoneCode+mobileController.text.trim(),widget.isLogin=="true"?true:false));
          }
        }),),

        SizedBox()
      ],
    ));
  }
}
