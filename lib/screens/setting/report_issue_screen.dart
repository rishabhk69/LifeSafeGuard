import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/bloc/support_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';

import '../../common/Utils/validations.dart';
import '../../common/service/dialog_service.dart';
import 'package:untitled/localization/fitness_localization.dart';


class ReportIssueScreen extends StatefulWidget {

  dynamic isReport;
  ReportIssueScreen(this.isReport);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {

  final formGlobalKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    TextEditingController titleController = TextEditingController();
    TextEditingController detailController = TextEditingController();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                context.pop();
              },
              child: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title:  Text(
            widget.isReport=="true"?GuardLocalizations.of(context)!.translate("reportAnIssue") ?? "":
            GuardLocalizations.of(context)!.translate("feedback") ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Form(
          key: formGlobalKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                 Text(GuardLocalizations.of(context)!.translate("addTitle") ?? "",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                CommonTextFieldWidget(
                  hintText: GuardLocalizations.of(context)!.translate("enterTitle") ?? "",
                  isPassword: false,
                  validator: (v){
                    return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("enterTitle") ?? "");
                  },
                  textController: titleController,
                ),

                const SizedBox(height: 16),

                // Details field
                 Text(GuardLocalizations.of(context)!.translate("details") ?? "",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

                CommonTextFieldWidget(
                  hintText: GuardLocalizations.of(context)!.translate("enterDetails") ?? "",
                  isPassword: false,
                  validator: (v){
                    return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("enterDetails") ?? "");
                  },
                  textController: detailController,
                ),

                const SizedBox(height: 16),

                // Attachments
                // const Text("Attachments",
                //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(16),
                //     decoration: BoxDecoration(
                //       color: Colors.grey[100],
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "Click to upload",
                //         style: TextStyle(color: Colors.grey),
                //       ),
                //     ),
                //   ),
                // ),
                //
                // const SizedBox(height: 12),

                // File List
                // Expanded(
                //   child: ListView(
                //     children: [
                //       _buildFileTile("xyz.pdf"),
                //       _buildFileTile("xyz.pdf"),
                //     ],
                //   ),
                // ),

                // Submit button

                BlocListener<SupportHelpBloc,SupportHelpState>(
                    listener: (context,supportListener){
                      if(supportListener is SupportHelpLoadingState){
                        locator<DialogService>().showLoader();
                      }
                      else if(supportListener is SupportHelpSuccessState){
                        locator<DialogService>().hideLoader();
                        context.pop();
                        locator<ToastService>().show(supportListener.supportHelpData.message??"");
                      }
                      else if(supportListener is SupportHelpErrorState){
                        locator<DialogService>().hideLoader();
                        locator<ToastService>().show(supportListener.errorMsg);
                      }
                    },
                    child: CustomButton(text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: (){
                      if(formGlobalKey.currentState!.validate()) {
                        locator<DialogService>().showLogoutDialog(
                            title: 'Confirm ?',
                            subTitle:widget.isReport=="true"?'Are you sure you want to report?': 'Are you sure you want to submit feedback?',
                            negativeButtonText: "No",
                            positiveButtonText: "Yes",
                            negativeTap: () {
                              context.pop();
                            },
                            positiveTap: () {
                              context.pop();
                              AppUtils().getUserData().then((onValue) {
                                var profileData = ProfileModel.fromJson(onValue);
                                BlocProvider.of<SupportHelpBloc>(context).add(
                                    SupportHelpRefreshEvent(
                                        supportType:widget.isReport=="true"? 'issue':'feedback',
                                        subject: titleController.text.trim(),
                                        details: detailController.text.trim(),
                                        inqueryType: '',
                                        name: profileData.userName,
                                        number: profileData.phone,
                                        email: ''
                                    )
                                );
                              });
                            }
                        );
                      }
                    }),
                  )

              ],

            ),
          ),
        ),
      ),
    );
  }
}