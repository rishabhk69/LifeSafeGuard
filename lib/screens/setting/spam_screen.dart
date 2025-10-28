import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/bloc/block_incident_bloc.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/strings.dart';

import '../../common/Utils/validations.dart';
import '../../common/service/dialog_service.dart';
import 'package:untitled/localization/fitness_localization.dart';


class SpamScreen extends StatefulWidget {
  dynamic incidentData;
  SpamScreen(this.incidentData);

  @override
  State<SpamScreen> createState() => _SpamScreenState();
}

class _SpamScreenState extends State<SpamScreen> {

  IncidentsModel? incidentsModel;
  final formGlobalKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        incidentsModel = widget.incidentData;
      });
    });
  }


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
          title:  Text(
            GuardLocalizations.of(context)!.translate("spamIncident") ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
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
                  hintText: GuardLocalizations.of(context)!.translate("whyAreYouBlockTheIncident") ?? "",
                  isPassword: false,
                  validator: (v){
                    return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("details") ?? "");
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

                BlocListener<BlockIncidentBloc,BlockIncidentState>(
                    listener: (context,blockState){
                      if(blockState is BlockIncidentLoadingState){
                        locator<DialogService>().showLoader();
                      }
                      else if(blockState is BlockIncidentSuccessState){
                        locator<DialogService>().hideLoader();
                        context.pop();
                        locator<ToastService>().show(blockState.blockIncidentData.status??"");
                        context.go('/dashboardScreen');
                        BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(0));
                      }
                      else if(blockState is BlockIncidentErrorState){
                        locator<DialogService>().hideLoader();
                        locator<ToastService>().show(blockState.errorMsg??"");
                      }
                    },
                    child: CustomButton(text: GuardLocalizations.of(context)!.translate("submit") ?? "", onTap: (){
                      if(formGlobalKey.currentState!.validate()) {
                        locator<DialogService>().showLogoutDialog(
                            title: 'Confirm ?',
                            subTitle: 'Are you sure you want to spam this incident?',
                            negativeButtonText: "No",
                            positiveButtonText: "Yes",
                            negativeTap: () {
                              context.pop();
                            },
                            positiveTap: () {
                              context.pop();
                              AppUtils().getUserId().then((userId) {
                                BlocProvider.of<BlockIncidentBloc>(context).add(
                                    BlockIncidentRefreshEvent(
                                        title: titleController.text.trim(),
                                        incidentId: incidentsModel
                                            ?.incidentId ?? "",
                                        userId: userId.toString(),
                                        description: detailController.text
                                            .trim(),
                                        urls: [])
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

  // File item widget
  Widget _buildFileTile(String filename) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(filename,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    );
  }
}