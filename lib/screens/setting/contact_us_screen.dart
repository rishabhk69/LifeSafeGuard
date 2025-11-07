import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/support_bloc.dart';
import 'package:untitled/common/Utils/validations.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/localization/fitness_localization.dart';


class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController helpController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String? selectedQuery = 'business';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                context.pop();
              },
              child: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Contact Us",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Form(
          key: formGlobalKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration
                SvgPicture.asset(
                  ImageHelper.contactUs,
                  height: 180,
                ),

                const SizedBox(height: 12),
                const Text(
                  "Get in Touch",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "If you have any inquiries get in touch with us.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 20),

                // Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: DropdownButtonFormField<String>(
                    validator: (v){
                      return Validations.phoneValidation(v,GuardLocalizations.of(context)!.translate("queryType") ?? "");
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    value: "business",
                    items: const [
                      DropdownMenuItem(
                          value: "business", child: Text("Business")),
                      DropdownMenuItem(
                          value: "investment",
                          child: Text("Investment")),
                      DropdownMenuItem(
                          value: "media", child: Text("Media")),
                      DropdownMenuItem(
                          value: "partnership", child: Text("Partnership")),
                      DropdownMenuItem(
                          value: "advertisement", child: Text("Advertisement")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedQuery = value;
                      });
                    },
                  ),
                ),


                CommonTextFieldWidget(
                    validator: (v){
                      return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("fullName") ?? "");
                    },
                    isPassword: false,
                    prefix:SvgPicture.asset(
                      ImageHelper.profileIc,
                      fit: BoxFit.scaleDown,
                      height: 20,
                      width: 20,
                    ),
                    hintText: GuardLocalizations.of(context)!.translate("fullName") ?? "",
                    textController: fullNameController),
                CommonTextFieldWidget(
                    validator: (v){
                      return Validations.phoneValidation(v,GuardLocalizations.of(context)!.translate("phoneNumber") ?? "");
                    },
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                    isPassword: false,
                    prefix: SvgPicture.asset(ImageHelper.callIc,
                      fit: BoxFit.scaleDown,
                      height: 20,
                      width: 20,),
                    hintText: GuardLocalizations.of(context)!.translate("phoneNumber") ?? "",
                    textController: numberController),
                CommonTextFieldWidget(
                    validator: (v){
                      return Validations.validEmailValidation(v);
                    },
                    prefix: SvgPicture.asset(ImageHelper.smsIc,
                      fit: BoxFit.scaleDown,
                      height: 20,
                      width: 20,),
                    isPassword: false,
                    hintText: GuardLocalizations.of(context)!.translate("emailAddress") ?? "",
                    textController: emailController),
                CommonTextFieldWidget(
                    validator: (v){
                      return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("howCanWeHelp") ?? "");
                    },
                    maxLines: 3,
                    isPassword: false,
                    hintText: GuardLocalizations.of(context)!.translate("howCanWeHelp") ?? "",
                    textController: helpController),

                const SizedBox(height: 20),

                BlocListener<SupportHelpBloc,SupportHelpState>(
                listener: (context,supportListener){
                  if(supportListener is SupportHelpLoadingState){
                    locator<DialogService>().showLoader();
                  }
                  else if(supportListener is SupportHelpSuccessState){
                    locator<DialogService>().hideLoader();
                    context.pop();
                    locator<ToastService>().show(supportListener.SupportHelpData.message??"");
                  }
                  else if(supportListener is SupportHelpErrorState){
                    locator<DialogService>().hideLoader();
                    locator<ToastService>().show(supportListener.errorMsg);
                  }

                },child:  CustomButton(text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: (){
                  if(formGlobalKey.currentState!.validate()){
                    // context.go('/dashboardScreen');
                    BlocProvider.of<SupportHelpBloc>(context,listen: false).add(SupportHelpRefreshEvent(
                        supportType: 'contact',
                        subject: helpController.text.trim(),
                        number: numberController.text.trim(),
                        inqueryType: selectedQuery,
                        email: emailController.text.trim(),
                        details: helpController.text.trim(),
                        name: fullNameController.text.trim()
                    ));
                  }
                }),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}