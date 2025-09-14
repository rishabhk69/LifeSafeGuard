import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/bloc/post_incidents_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/common/Utils/validations.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';
import 'package:video_compress/video_compress.dart';

import '../../constants/base_appbar.dart';
import '../../constants/common_function.dart' show CommonFunction;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController titleController =TextEditingController();
  TextEditingController detailController =TextEditingController();
  bool isAnonymous = false;
  bool isVideo = true;
  XFile? selectedFile;
  final formGlobalKey = GlobalKey<FormState>();

  @override
    void initState() {
      super.initState();
      BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent( StringHelper.bomBlast));
      getAddress();
    }

    getAddress()async{
      String address = await CommonFunction().getAddressFromCurrentLocation();
      print("Current Address: $address");

    }

  @override
  Widget build(BuildContext context) {
    AppUtils().getToken().then((onValue){
      print(onValue);
    });
    return  Scaffold(
      appBar: BaseAppBar(title: StringHelper.reportIncident,showAction: true,
      isVideo: isVideo,
      onActionTap: (){
        setState(() {
          isVideo = !isVideo;
        });
      },
      ),
      backgroundColor: ColorConstant.scaffoldColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Video Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                selectedFile == null ?Column(
                  children: [
                    Text(
                      isVideo ? StringHelper.uploadVideo : StringHelper.uploadImage,
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                      label: Text( isVideo ? StringHelper.shootVideo: StringHelper.shootImage,style: GoogleFonts.poppins(
                        color: ColorConstant.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),),
                      onPressed: () async {
                        await CommonFunction().pickImageVideoFile(!isVideo,false,context).then((value) async {
                          if (value != null && isVideo) {
                            selectedFile = XFile(value.path);
                            CommonFunction().compressVideo(value).then((v) async {
                              selectedFile = null;
                              selectedFile = XFile(v!.path);
                              await VideoCompress.getFileThumbnail(selectedFile!.path).then((onValue){
                                setState(() {
                                  selectedFile = XFile(onValue.path);
                                });
                              });

                            });
                          }
                          else if(value != null && !isVideo){
                            setState(() {
                              selectedFile = value;
                            });
                          }
                          else{
                            return null;
                          }
                          // context.pop();
                          // BlocProvider.of<FileSelectionBloc>(context).add(FileSelectionRefreshEvent((value),isPhoto:0));
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.photo_library_outlined, color: Colors.white),
                      label: Text(StringHelper.chooseFromGallery,style: GoogleFonts.poppins(
                          color: ColorConstant.whiteColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),),
                      onPressed: () async {
                        await CommonFunction().pickImageVideoFile(!isVideo,true,context).then((value) async {
                          if (value != null){
                            FileStat stat = await File(value.path).stat();
                            print("Created: ${stat.changed}");
                            print("Modified: ${stat.modified}");
                            print("Accessed: ${stat.accessed}");
                          }
                          if (value != null && isVideo) {
                            selectedFile = XFile(value.path);
                            CommonFunction().compressVideo(value).then((v) async {
                              selectedFile = null;
                              selectedFile = XFile(v!.path);
                             await VideoCompress.getFileThumbnail(selectedFile!.path).then((onValue){
                                setState(() {
                                  selectedFile = XFile(onValue.path);
                                });
                              });

                            });
                          }
                          else if(value != null && !isVideo){
                            setState(() {
                              selectedFile = value;
                            });
                          }
                          else{
                            return null;
                          }
                          // context.pop();
                          // BlocProvider.of<FileSelectionBloc>(context).add(FileSelectionRefreshEvent((value),isPhoto:0));
                        });
                      },
                    ),
                  ],
                ) : Stack(
                  children: [
                    SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.file(File(selectedFile!.path,),fit: BoxFit.fill,)),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                          color: ColorConstant.whiteColor,
                          onPressed: (){
                        setState(() {
                          selectedFile= null;
                        });
                      }, icon: Icon(Icons.delete)),
                    )
                  ],
                )
              ),

              const SizedBox(height: 20),

              // Type of Incident
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(StringHelper.typeOfIncident,
                          style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      context.push('/incidentTypeScreen').then((onValue){
                        print("rishabh:$onValue");
                      });
                      // open bottomsheet or dropdown for selection
                    },
                    child: Row(
                      children: [
                        Text(BlocProvider.of<SetIncidentsBloc>(context).selectedIncident??"",
                            style:GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w400,color: Color(0xff191919))),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Anonymous Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(StringHelper.anonymous,
                          style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                    ],
                  ),
                  InkWell(
                      onTap: (){
                       setState(() {
                         isAnonymous= !isAnonymous;
                       });
                      },
                      child: SvgPicture.asset(isAnonymous == false ?ImageHelper.imageDisableToggle: ImageHelper.imageEnableToggle))
                ],
              ),

              const SizedBox(height: 20),

              // Add Title
              Text(StringHelper.addTitle, style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
              CommonTextFieldWidget(
                maxLength: 50,
                validator: (v){
                  return Validations.commonValidation(v,StringHelper.enterTitle);
                },
                hintText: StringHelper.enterTitle, isPassword: false, textController: titleController,

              ),

              const SizedBox(height: 10),

              // Details
              Text("Details", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
              CommonTextFieldWidget(
                maxLines: 2,
                validator: (v){
                  return Validations.commonValidation(v,StringHelper.enterIncidentDetails);
                },
                hintText: StringHelper.enterIncidentDetails, isPassword: false, textController: detailController,

              ),

              const SizedBox(height: 30),

              // Post Button
              BlocListener<PostIncidentsBloc,PostIncidentsState>(
                listener: (context,blocListener){
                if(blocListener is PostIncidentsLoadingState){
                  locator<DialogService>().showLoader();
                }
                else if(blocListener is PostIncidentsSuccessState){
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(blocListener.postIncidentsData.message??"");
                  titleController.clear();
                  detailController.clear();
                  selectedFile = null;
                }
                else if(blocListener is PostIncidentsErrorState){
                  titleController.clear();
                  detailController.clear();
                  selectedFile = null;
                  locator<ToastService>().show(blocListener.errorMsg??"");
                  locator<DialogService>().hideLoader();
                }
              },child: CustomButton(text: StringHelper.post, onTap: (){
                if(formGlobalKey.currentState!.validate()){
                  if(selectedFile!=null){
                    BlocProvider.of<PostIncidentsBloc>(context).add(PostIncidentsRefreshEvent(
                        category: BlocProvider.of<SetIncidentsBloc>(context).selectedIncident??"",
                        description: detailController.text.trim(),
                        files: File(selectedFile!.path),
                        isCameraUpload: true,
                        isVideo: false,
                        latitude: '26.91659519426711',
                        longitude: '75.77709914116316',
                        reportAnonymously: isAnonymous,
                        title: titleController.text.trim()
                    ));
                  }
                  else{
                    locator<ToastService>().show(StringHelper.uploadImage);
                  }
                }
              }),)

            ],
          ),
        ),
      ),
    );
  }
}
