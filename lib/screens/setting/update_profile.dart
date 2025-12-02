import 'dart:io';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/bloc/update_profile_bloc.dart';
import 'package:untitled/localization/fitness_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/Utils/validations.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/common_function.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';

class UpdateProfileScreen extends StatefulWidget {

  UpdateProfileScreen();


  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {


  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController uNameController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  XFile? selectedFile;
  String? userId;


  setPreFill(){
    AppUtils().getUserData().then((onValue){
      var profileData = ProfileModel.fromJson(onValue);
     setState(() {
       fNameController.text = profileData.firstName??"";
       lNameController.text = profileData.lastName??"";
       uNameController.text = profileData.userName??"";
       userId = profileData.userId??"";
     });
    });
  }

  @override
  void initState() {
    super.initState();
    setPreFill();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.35,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(ImageHelper.bgImage),fit: BoxFit.fill),
                  // color: ColorConstant.primaryColor,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(60),
                  //   bottomRight: Radius.circular(60),
                  // ),
                ),
              ),

              // White content area
              Positioned(
                top: size.height * 0.20,
                // bottom: size.height * 0.12,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height,
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child:  Form(
                    key: formGlobalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CommonTextFieldWidget(isPassword: false,
                                validator: (v){
                                  return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("firstName") ?? "");
                                },
                                hintText: GuardLocalizations.of(context)!.translate("firstName") ?? "",
                                maxLength: 20,
                                textController: fNameController),
                            CommonTextFieldWidget(isPassword: false,
                              // validator: (v){
                              //   return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("lastName") ?? "");
                              // },
                              hintText: GuardLocalizations.of(context)!.translate("lastName") ?? "",
                              textController: lNameController,
                              maxLength: 20,),
                            CommonTextFieldWidget(isPassword: false,
                                enable: false,
                                validator: (v){
                                  return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("userName") ?? "");
                                },
                                hintText: GuardLocalizations.of(context)!.translate("userName") ?? "",
                                maxLength: 20,
                                textController: uNameController)
                            // _buildTextField(Icons.person, GuardLocalizations.of(context)!.translate("firstName") ?? ""),
                            // _buildTextField(Icons.person, GuardLocalizations.of(context)!.translate("lastName") ?? ""),
                            // _buildTextField(Icons.person, GuardLocalizations.of(context)!.translate("userName") ?? ""),
                          ],
                        ),

                        BlocListener<UpdateProfileBloc,UpdateProfileState>(
                          listener: (context,loginState){
                            if(loginState is UpdateProfileLoadingState){
                              locator<DialogService>().showLoader();
                            }
                            else if(loginState is UpdateProfileSuccessState){
                              locator<DialogService>().hideLoader();
                              locator<ToastService>().show(loginState.commonModel.message??"");
                              context.go('/dashboardScreen');
                              BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(0));
                            }
                            else if(loginState is UpdateProfileErrorState){
                              locator<DialogService>().hideLoader();
                              locator<ToastService>().show(loginState.errorMsg??"");
                            }
                          },child:  CustomButton(
                            buttonHeight: 50,
                            text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: (){
                          if(formGlobalKey.currentState!.validate()){
                            // if(selectedFile==null){
                            //   locator<ToastService>().show('Please Select Image');
                            // }
                            // else{
                              BlocProvider.of<UpdateProfileBloc>(context).add(UpdateProfileRefreshEvent(
                                  userId: userId,
                                  profilePhoto: selectedFile==null?  null:File(selectedFile!.path),
                                  lastName: lNameController.text.trim(),
                                  firstName: fNameController.text.trim()
                              ));
                            // }
                          }
                        }),),

                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: 100,
                child: InkWell(
                  onTap: (){
                    CommonFunction().pickImage('gallery').then((onValue){
                      if(onValue.path.isNotEmpty){
                        setState(() {
                          selectedFile = onValue;
                          locator<ToastService>().show('Image Successfully Picked');
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 140,
                      width: 140,
                      // padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.primaryColor),
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage:
                          selectedFile != null ? FileImage(File(selectedFile!.path)) : null,
                          child: selectedFile == null
                              ? SvgPicture.asset(ImageHelper.cameraIc, fit: BoxFit.cover)
                              : null,
                        )

                      ),
                    ),
                  ),
                ),
              ),
              if(true)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 15,
                  child: InkWell(
                    onTap: (){
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.keyboard_backspace_outlined,color: ColorConstant.whiteColor,),
                          Text(
                          GuardLocalizations.of(context)!.translate("update") ?? "" ,style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: ColorConstant.whiteColor,
                              fontWeight: FontWeight.w500
                          ),),
                          SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
