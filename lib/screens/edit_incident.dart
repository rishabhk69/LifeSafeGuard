import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/bloc/edit_incidents_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:video_compress/video_compress.dart';
import 'package:untitled/localization/fitness_localization.dart';

class EditIncidentScreen extends StatefulWidget {
  final dynamic incidentData;

  const EditIncidentScreen({super.key, required this.incidentData});

  @override
  State<EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends State<EditIncidentScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  bool isAnonymous = false;
  bool isVideo = false;
  bool? isCameraUpload;
  String? createdDate;

  @override
  void initState() {
    super.initState();

    /// PREFILL DATA HERE
    titleController.text = widget.incidentData.title ?? "";
    detailController.text = widget.incidentData.desc ?? "";
    // isAnonymous = widget.incidentData.reportAnonymously ?? false;

    // createdDate = widget.incidentData.time;
    // // BlocProvider.of<SetIncidentsBloc>(context).setSelectedIncident(widget.incidentData.category ?? "Select Type");


    // if (selectedFiles.isNotEmpty &&
    //     selectedFiles[0].path.toLowerCase().contains(".mp4")) {
    //   isVideo = true;
    // }
    // if (widget.incidentData.media != null &&  isVideo) {
    //   for (var m in widget.incidentData.media) {
    //     selectedFiles.add(XFile(AppConfig.VIDEO_BASE_URL+m.name)); // you must store URLs directly
    //   }
    //
    // }
    // else{
    //   for (var m in widget.incidentData.media) {
    //     selectedFiles.add(m); // you must store URLs directly
    //   }
    // }
  }

  Future<File> getThumbnail(XFile thumbnailFile) async {
    final file = await VideoCompress.getFileThumbnail(thumbnailFile.path);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          GuardLocalizations.of(context)!.translate("editIncident") ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      backgroundColor: ColorConstant.scaffoldColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ------------------- MEDIA SECTION -------------------
            _buildMediaSection(context),
            const SizedBox(height: 20),

            /// ------------------- INCIDENT TYPE -------------------
            _buildIncidentType(context),
            const SizedBox(height: 20),

            /// ------------------- ANONYMOUS -------------------
            _buildAnonymousToggle(context),
            const SizedBox(height: 20),

            // Add Title
            Text(GuardLocalizations.of(context)!.translate("addTitle") ?? "", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              maxLength: 50,
              // validator: (v){
              //   return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("enterTitle") ?? "");
              // },
              hintText: GuardLocalizations.of(context)!.translate("enterTitle") ?? "", isPassword: false, textController: titleController,

            ),

            const SizedBox(height: 10),

            // Details
            Text("Details", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              maxLines: 2,
              // validator: (v){
              //   return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("enterIncidentDetails") ?? "");
              // },
              hintText: GuardLocalizations.of(context)!.translate("enterIncidentDetails") ?? "", isPassword: false, textController: detailController,

            ),
            const SizedBox(height: 30),

            BlocListener<EditIncidentsBloc, EditIncidentsState>(
              listener: (context, state) {
                if (state is EditIncidentsLoadingState) {
                  locator<DialogService>().showLoader();
                } else if (state is EditIncidentsSuccessState) {
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show("Incident Updated Successfully");
                  Navigator.pop(context);
                } else if (state is EditIncidentsErrorState) {
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(state.errorMsg);
                }
              },
              child: CustomButton(
                text: "Update",
                onTap: () {
                    if (BlocProvider
                        .of<SetIncidentsBloc>(context)
                        .selectedIncident == 'Select Type') {
                      locator<ToastService>().show(
                          'Please select incident type');
                    }
                    else{
                      BlocProvider.of<EditIncidentsBloc>(context).add(
                        EditIncidentsRefreshEvent(
                          incidentId: widget.incidentData.id,
                          category: BlocProvider.of<SetIncidentsBloc>(context).selectedIncident,
                          description: detailController.text.trim(),
                          title: titleController.text.trim(),
                          reportAnonymously: isAnonymous,
                        ),
                      );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------ MEDIA SECTION ------------------------
  Widget _buildMediaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child:/* selectedFiles.isEmpty
          ?*/ Center(child: Text("No media found"))
          // : isVideo
          // ? _buildVideoPreview(context)
          // : _buildImagePreview(context),
    );
  }

  // Widget _buildImagePreview(BuildContext context) {
  //   return Stack(
  //     children: [
  //       SizedBox(
  //         height: 150,
  //         child: CarouselSlider.builder(
  //           itemCount: selectedFiles.length,
  //           itemBuilder: (_, i, __) =>
  //               Image.file(File(selectedFiles[i].path), fit: BoxFit.cover),
  //           options: CarouselOptions(
  //             viewportFraction: 1,
  //             autoPlay: true,
  //             onPageChanged: (i, _) {
  //               setState(() => _currentIndex = i);
  //             },
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         right: -10,
  //         top: -10,
  //         child: IconButton(
  //           icon: Icon(Icons.add_circle_outline, color: Colors.grey),
  //           onPressed: () async {
  //             final files = await ImagePicker().pickMultiImage();
  //             if (files.isNotEmpty) {
  //               setState(() {
  //                 selectedFiles.addAll(files);
  //               });
  //             }
  //           },
  //         ),
  //       ),
  //       Positioned(
  //         bottom: -10,
  //         right: -10,
  //         child: IconButton(
  //           icon: Icon(Icons.delete, color: Colors.grey),
  //           onPressed: () {
  //             setState(() {
  //               selectedFiles.removeAt(_currentIndex);
  //             });
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildIncidentType(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(Icons.category, color: Colors.orange),
          SizedBox(width: 8),
          Text("Type of Incident",
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500)),
        ]),
        InkWell(
          onTap: () => context.push('/incidentTypeScreen'),
          child: Row(
            children: [
              Text(
                BlocProvider.of<SetIncidentsBloc>(context).selectedIncident,
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        )
      ],
    );
  }

  // ------------------------ ANONYMOUS TOGGLE ------------------------
  Widget _buildAnonymousToggle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(Icons.person_outline, color: Colors.orange),
          SizedBox(width: 8),
          Text("Anonymous",
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500)),
        ]),
        InkWell(
          onTap: () => setState(() => isAnonymous = !isAnonymous),
          child: SvgPicture.asset(isAnonymous
              ? ImageHelper.imageEnableToggle
              : ImageHelper.imageDisableToggle),
        )
      ],
    );
  }
}
