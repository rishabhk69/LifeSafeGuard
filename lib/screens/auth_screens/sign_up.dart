import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/bloc/auth/signup_bloc.dart';
import 'package:untitled/common/Utils/validations.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/common_background.dart';
import 'package:untitled/constants/common_function.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController fNameController = TextEditingController();
    TextEditingController lNameController = TextEditingController();
    TextEditingController uNameController = TextEditingController();
    final formGlobalKey = GlobalKey<FormState>();
    XFile? selectedFile;

    return CommonBackground(
      onTap: (){
        CommonFunction().pickImage('gallery').then((onValue){
          selectedFile = onValue;
          if(selectedFile!.path.isNotEmpty){
            locator<ToastService>().show('Image Successfully Picked');
          }
        });
      },
      iconName:selectedFile ?? ImageHelper.cameraIc,
      title: StringHelper.signUP,
      showBack: true,
      child:  Form(
        key: formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CommonTextFieldWidget(isPassword: false,
                    validator: (v){
                      return Validations.commonValidation(v,StringHelper.firstName);
                    },
                    hintText: StringHelper.firstName,
                    maxLength: 20,
                    textController: fNameController),
                CommonTextFieldWidget(isPassword: false,
                    validator: (v){
                      return Validations.commonValidation(v,StringHelper.lastName);
                    },
                    hintText: StringHelper.lastName,
                    textController: lNameController,
                     maxLength: 20,),
                CommonTextFieldWidget(isPassword: false,
                    validator: (v){
                      return Validations.commonValidation(v,StringHelper.userName);
                    },
                    hintText: StringHelper.userName,
                    maxLength: 20,
                    textController: uNameController)
                // _buildTextField(Icons.person, StringHelper.firstName),
                // _buildTextField(Icons.person, StringHelper.lastName),
                // _buildTextField(Icons.person, StringHelper.userName),
              ],
            ),

            BlocListener<SignupBloc,SignupState>(
              listener: (context,loginState){
                if(loginState is SignupLoadingState){
                  locator<DialogService>().showLoader();
                }
                else if(loginState is SignupSuccessState){
                  locator<DialogService>().hideLoader();
                  AppUtils().setUserLoggedIn();
                  AppUtils().setUserId(loginState.signupData.userId??"");
                  locator<ToastService>().show(loginState.signupData.message??"");
                  context.go('/dashboardScreen');
                }
                else if(loginState is SignupErrorState){
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(loginState.errorMsg??"");
                }
              },child:  CustomButton(
                buttonHeight: 50,
                text: StringHelper.submit, onTap: (){
              if(formGlobalKey.currentState!.validate()){
                if(selectedFile==null){
                  locator<ToastService>().show('Please Select Image');
                }
                else{
                  BlocProvider.of<SignupBloc>(context).add(SignupRefreshEvent(
                      userName: uNameController.text.trim(),
                      profilePhoto: File(selectedFile!.path),
                      lastName: lNameController.text.trim(),
                      firstName: fNameController.text.trim()
                  ));
                }
              }
            }),),

            SizedBox(),
          ],
        ),
      )
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField(IconData icon, String hint) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
