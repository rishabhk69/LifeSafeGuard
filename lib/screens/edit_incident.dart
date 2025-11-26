import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/bloc/post_incidents_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/screens/other_screens/preview_images.dart';
import 'package:video_compress/video_compress.dart';

import '../../constants/app_styles.dart';
import '../../constants/base_appbar.dart';
import '../../main.dart';
import 'package:untitled/localization/fitness_localization.dart';

class EditIncidentScreen extends StatefulWidget {
  final dynamic incidentData; // <-- passing full model

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
  List<XFile> selectedFiles = [];
  int _currentIndex = 0;
  String? createdDate;

  @override
  void initState() {
    super.initState();

    /// PREFILL DATA HERE
    titleController.text = widget.incidentData.title ?? "";
    // detailController.text = widget.incidentData.description ?? "";
    // isAnonymous = widget.incidentData.reportAnonymously ?? false;

    createdDate = widget.incidentData.time;
    // BlocProvider.of<SetIncidentsBloc>(context).setSelectedIncident(widget.incidentData.category ?? "Select Type");

    /// Load images/videos from URL
    // if (widget.incidentData.media != null) {
    //   for (var m in widget.incidentData.media) {
    //     selectedFiles.add(XFile(m)); // you must store URLs directly
    //   }
    //
    //   if (selectedFiles.isNotEmpty &&
    //       selectedFiles[0].path.toLowerCase().contains(".mp4")) {
    //     isVideo = true;
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
      appBar: BaseAppBar(
        title: "Edit Incident",
        showAction: false,
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

            /// ------------------- TITLE -------------------
            Text("Add Title",
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              maxLength: 50,
              hintText: "Enter title",
              isPassword: false,
              textController: titleController,
            ),
            const SizedBox(height: 10),

            /// ------------------- DETAILS -------------------
            Text("Details",
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              maxLines: 2,
              hintText: "Enter details",
              isPassword: false,
              textController: detailController,
            ),

            const SizedBox(height: 30),

            /// ------------------- UPDATE BUTTON -------------------
            BlocListener<PostIncidentsBloc, PostIncidentsState>(
              listener: (context, state) {
                if (state is PostIncidentsLoadingState) {
                  locator<DialogService>().showLoader();
                } else if (state is PostIncidentsSuccessState) {
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show("Incident Updated Successfully");
                  Navigator.pop(context);
                } else if (state is PostIncidentsErrorState) {
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(state.errorMsg ?? "");
                }
              },
              child: CustomButton(
                text: "Update",
                onTap: () {
                  if (selectedFiles.isEmpty) {
                    locator<ToastService>().show("Please upload media");
                    return;
                  }

                  // BlocProvider.of<PostIncidentsBloc>(context).add(
                  //   PostIncidentsRefreshEvent(
                  //     isEdited: true, // <-- IMPORTANT
                  //     incidentId: widget.incidentData.id, // <-- pass ID
                  //
                  //     category: BlocProvider.of<SetIncidentsBloc>(context)
                  //         .selectedIncident ??
                  //         "",
                  //     description: detailController.text.trim(),
                  //     files:
                  //     selectedFiles.map((f) => File(f.path)).toList(),
                  //     isCameraUpload: isCameraUpload,
                  //     isVideo: isVideo,
                  //     title: titleController.text.trim(),
                  //     reportAnonymously: isAnonymous,
                  //     time: createdDate,
                  //   ),
                  // );
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
      child: selectedFiles.isEmpty
          ? Center(child: Text("No media found"))
          : isVideo
          ? _buildVideoPreview(context)
          : _buildImagePreview(context),
    );
  }

  // ------------------------ VIDEO PREVIEW ------------------------
  Widget _buildVideoPreview(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: FutureBuilder<File>(
            future: getThumbnail(selectedFiles[0]),
            builder: (context, snap) {
              if (!snap.hasData) return Center(child: CircularProgressIndicator());
              return Stack(
                children: [
                  Image.file(snap.data!, fit: BoxFit.cover),
                  Center(
                    child: Icon(Icons.play_circle,
                        size: 50, color: Colors.white),
                  )
                ],
              );
            },
          ),
        ),
        Positioned(
          bottom: -10,
          right: -10,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              setState(() => selectedFiles.clear());
            },
          ),
        )
      ],
    );
  }

  // ------------------------ IMAGE PREVIEW ------------------------
  Widget _buildImagePreview(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          child: CarouselSlider.builder(
            itemCount: selectedFiles.length,
            itemBuilder: (_, i, __) =>
                Image.file(File(selectedFiles[i].path), fit: BoxFit.cover),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (i, _) {
                setState(() => _currentIndex = i);
              },
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: -10,
          child: IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.grey),
            onPressed: () async {
              final files = await ImagePicker().pickMultiImage();
              if (files.isNotEmpty) {
                setState(() {
                  selectedFiles.addAll(files);
                });
              }
            },
          ),
        ),
        Positioned(
          bottom: -10,
          right: -10,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              setState(() {
                selectedFiles.removeAt(_currentIndex);
              });
            },
          ),
        )
      ],
    );
  }

  // ------------------------ INCIDENT TYPE ------------------------
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
