import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
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
import '../../constants/common_function.dart' show CommonFunction, LocationData, getLocationData;
import '../../main.dart';
import 'package:untitled/localization/fitness_localization.dart';


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
  bool? isCameraUpload;
  List<XFile> selectedFiles = [];
  final formGlobalKey = GlobalKey<FormState>();
  String? userId;
  LocationData? data;
  String? createdDate;
  int _currentIndex = 0;

  @override
    void initState() {
      super.initState();
     WidgetsBinding.instance.addPostFrameCallback((callback){
       getUserId();
     });
    }
  Future<void> getUserId() async {
    final id = await AppUtils().getUserId();
    final loc = await getLocationData();


    if (!mounted) return;
    setState(() {
      userId = id;
      data = loc;
    });
  }


  Future<File> getThumbnail(XFile thumbnailFile) async {
    final file = await VideoCompress.getFileThumbnail(thumbnailFile.path);
    return file;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BaseAppBar(title: GuardLocalizations.of(context)!.translate("reportIncident") ?? "",showAction: true,
      isVideo: isVideo,
      onActionTap: (){
       if(selectedFiles.isNotEmpty){
         locator<DialogService>().showCommonDialog(context, Padding(
           padding: const EdgeInsets.all(10),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               addHeight(10),
               Text(
                 GuardLocalizations.of(context)!.translate("fileAlreadySelectedYouWantToReplace") ?? "",
                 style: MyTextStyleBase.headingStyleLight,
                 textAlign: TextAlign.center,),
               addHeight(20),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   ElevatedButton(
                     child: Text(GuardLocalizations.of(context)!.translate("yes") ?? "",style: MyTextStyleBase.headingStyleLight,),
                     onPressed: (){
                       context.pop();
                       selectedFiles=[];
                       setState(() {
                         isVideo = !isVideo;
                       });
                       // context.push('/incidentDetails',extra: incidentState.incidentsModel[index]);
                     },
                   ),
                   ElevatedButton(
                     child: Text(GuardLocalizations.of(context)!.translate("no") ?? "",style: MyTextStyleBase.headingStyleLight,),
                     onPressed: (){
                       context.pop();
                       // context.push('/incidentDetails',extra: incidentState.incidentsModel[index]);
                     },
                   ),
                 ],
               ),
             ],
           ),
         ));
       }
       else {
         setState(() {
           isVideo = !isVideo;
         });
       }
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
                selectedFiles.isEmpty ?Column(
                  children: [
                    Text(
                      isVideo ? GuardLocalizations.of(context)!.translate("uploadVideo") ?? "" : GuardLocalizations.of(context)!.translate("uploadImage") ?? "",
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
                      label: Text( isVideo ? GuardLocalizations.of(context)!.translate("shootVideo") ?? "": GuardLocalizations.of(context)!.translate("shootImage") ?? "",style: GoogleFonts.poppins(
                        color: ColorConstant.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),),
                      onPressed: () async {
                        await CommonFunction().pickImageVideoFile(!isVideo, false, context).then((files) async {
                          if (files != null && files.isNotEmpty) {
                            if (isVideo) {
                              XFile videoFile = files.first;
                              selectedFiles = [];
                              selectedFiles.add(videoFile);
                              CommonFunction().compressVideo(videoFile,context).then((compressed) async {
                                if (compressed != null) {
                                  locator<DialogService>().hideLoader();
                                  setState(() {
                                    selectedFiles = [XFile(compressed.path)];
                                    createdDate = currentDate;
                                    isCameraUpload = true;
                                  });
                                }
                              });
                            } else {
                              // ---- MULTIPLE IMAGES ----
                              setState(() {
                                selectedFiles = files; // directly assign all picked images
                                createdDate = currentDate;
                                isCameraUpload = true;
                              });
                            }
                          } else {
                            return null;
                          }
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
                      label: Text(GuardLocalizations.of(context)!.translate("chooseFromGallery") ?? "",style: GoogleFonts.poppins(
                          color: ColorConstant.whiteColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),),
                      onPressed: () async {
                        await CommonFunction().pickImageVideoFile(!isVideo, true, context).then((files) async {
                          if (files != null && files.isNotEmpty) {
                            if (isVideo) {
                             try{
                               XFile videoFile = files.first;
                               selectedFiles = [];
                               FileStat stat = await File(videoFile.path).stat();
                               createdDate = stat.accessed.toString();

                               CommonFunction().compressVideo(videoFile,context).then((v) async {
                                 if (v != null) {
                                   setState(() {
                                     selectedFiles = [XFile(v.path)];
                                     createdDate = stat.accessed.toString();
                                     isCameraUpload = false;
                                   });
                                   // locator<DialogService>().hideLoader();
                                 }
                               });
                             }
                             catch(e){
                               print(e);
                             }
                            } else {
                              // ---- MULTIPLE IMAGES ----
                              List<FileStat> stats = await Future.wait(
                                files.map((file) => File(file.path).stat()),
                              );

                              setState(() {
                                selectedFiles = files;
                                createdDate = stats.first.accessed.toString(); // take first image’s timestamp
                                isCameraUpload = false;
                              });
                            }
                          } else {
                            return null;
                          }
                        });

                      },
                    ),
                  ],
                ) : isVideo ?
                Stack(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewGallery(
                              mediaFiles:selectedFiles.map((x) => File(x.path)).toList(),
                              initialIndex: 0, // Optional
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: FutureBuilder<File>(
                          future: getThumbnail(selectedFiles[0]), // async call
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Icon(Icons.error, color: Colors.red));
                            } else if (snapshot.hasData) {
                              return Center(
                                child: Stack(
                                  children: [
                                    Image.file(
                                      snapshot.data!,
                                      // fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Icon(Icons.play_circle,size: 50,color: ColorConstant.whiteColor,))
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                          color: ColorConstant.whiteColor,
                          onPressed: (){
                            locator<DialogService>().showLogoutDialog(
                              negativeButtonText: GuardLocalizations.of(context)!.translate("no") ?? "",
                              subTitle: GuardLocalizations.of(context)!.translate("areYouSureYouWantToDelete") ?? "",
                              positiveButtonText: GuardLocalizations.of(context)!.translate("yes") ?? "",
                              negativeTap: (){
                                context.pop();
                              },
                              positiveTap: (){
                                context.pop();
                                setState(() {
                                  selectedFiles.clear();
                                });
                              }
                            );

                          }, icon: Icon(Icons.delete,color: Colors.grey,)),
                    ),

                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   top: 0,
                    //   left: 0,
                    //   child: IconButton(
                    //       color: ColorConstant.whiteColor,
                    //       onPressed: (){
                    //         setState(() {
                    //           selectedFile= null;
                    //         });
                    //       }, icon: Icon(Icons.play_circle,size: 50,blendMode: BlendMode.lighten,)),
                    // )
                  ],
                ) :
                Stack(
                  children: [

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewGallery(
                              mediaFiles:selectedFiles.map((x) => File(x.path)).toList(),
                              initialIndex: 0, // Optional
                            ),
                          ),
                        );

                      },
                      child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: CarouselSlider.builder(
                            itemCount: selectedFiles.length,
                            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                Image.file(File(selectedFiles[itemIndex].path,),fit: BoxFit.fitWidth,),
                            options: CarouselOptions(
                              height: 400,
                              // aspectRatio: 16/9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: selectedFiles.length>1 ?true:false,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          // child: Image.file(File(selectedFiles[0]!.path,),fit: BoxFit.fill,)
                      ),
                    ),

                    if(selectedFiles.length<=5)
                    Positioned(
                        right: -10,
                        left: 0,
                        top: -10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                            onPressed: () async {
                              await CommonFunction().pickImageVideoFile(!isVideo, false, context).then((files) async {
                                if (files != null && files.isNotEmpty) {
                                    setState(() {
                                      selectedFiles.add(files.first); // directly assign all picked images
                                      createdDate = currentDate;
                                      isCameraUpload = true;
                                    });

                                } else {
                                  return null;
                                }
                              });

                            }, icon: Icon(Icons.add_circle_outline,color: Colors.grey,),),
                          ],
                        )),

                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                          color: ColorConstant.whiteColor,
                          onPressed: (){
                            locator<DialogService>().showLogoutDialog(
                                negativeButtonText: GuardLocalizations.of(context)!.translate("no") ?? "",
                                subTitle: GuardLocalizations.of(context)!.translate("areYouSureYouWantToDelete") ?? "",
                                positiveButtonText: GuardLocalizations.of(context)!.translate("yes") ?? "",
                                negativeTap: (){
                                  context.pop();
                                },
                                positiveTap: (){
                                  context.pop();
                                  setState(() {
                                    selectedFiles.removeAt(_currentIndex); // ✅ delete current
                                    if (_currentIndex >= selectedFiles.length && _currentIndex > 0) {
                                      _currentIndex--; // move index safely if last item removed
                                    }
                                  });
                                },
                            );
                      }, icon: Icon(Icons.delete,color: Colors.grey,)),
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
                      Text(GuardLocalizations.of(context)!.translate("typeOfIncident") ?? "",
                          style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      context.push('/incidentTypeScreen').then((onValue){
                      });
                    },
                    child: Row(
                      children: [
                        Text(BlocProvider.of<SetIncidentsBloc>(context).selectedIncident.length>15 ?
                        '${BlocProvider.of<SetIncidentsBloc>(context).selectedIncident.substring(0,15)}...':
                        BlocProvider.of<SetIncidentsBloc>(context).selectedIncident,
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
                      Text(GuardLocalizations.of(context)!.translate("anonymous") ?? "",
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

              // Post Button
              BlocListener<PostIncidentsBloc,PostIncidentsState>(
                listener: (context,blocListener){
                if(blocListener is PostIncidentsLoadingState){
                  locator<DialogService>().showLoader();
                }
                else if(blocListener is PostIncidentsSuccessState){
                  locator<DialogService>().hideLoader();
                  locator<ToastService>().show(blocListener.postIncidentsData.message??"");
                  clearSelected();
                }
                else if(blocListener is PostIncidentsErrorState){
                  clearSelected();
                  locator<ToastService>().show(blocListener.errorMsg??"");
                  locator<DialogService>().hideLoader();
                }
              },child: CustomButton(text: GuardLocalizations.of(context)!.translate("post") ?? "", onTap: (){
                // if(formGlobalKey.currentState!.validate()){
                  if(selectedFiles.isNotEmpty){
                    if(BlocProvider.of<SetIncidentsBloc>(context).selectedIncident == 'Select Type'){
                      locator<ToastService>().show('Please select incident type');
                    }
                    else {
                      BlocProvider.of<PostIncidentsBloc>(context).add(
                          PostIncidentsRefreshEvent(
                              category: BlocProvider
                                  .of<SetIncidentsBloc>(context)
                                  .selectedIncident ?? "",
                              description: detailController.text.trim(),
                              files: selectedFiles
                                  .map((f) => File(f.path))
                                  .toList(),
                              isCameraUpload: isCameraUpload,
                              isVideo: isVideo,
                              latitude: data?.latitude.toString() ?? "0.0",
                              longitude: data?.longitude.toString() ?? "0.0",
                              reportAnonymously: isAnonymous,
                              title: titleController.text.trim(),
                              userId: userId,
                              state: data?.state,
                              isEdited: false,
                              city: data?.city,
                              address: data?.address,
                              pinCode: data?.postCode,
                              time: createdDate
                          ));
                    }
                  }
                  else{
                    locator<ToastService>().show(GuardLocalizations.of(context)!.translate("uploadImage") ?? "");
                  }
                // }
              }),)

            ],
          ),
        ),
      ),
    );
  }


  clearSelected(){
    setState(() {
      titleController.clear();
      detailController.clear();
      selectedFiles.clear();
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
