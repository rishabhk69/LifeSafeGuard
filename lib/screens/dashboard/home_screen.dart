import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/file_selection_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/navigation_service.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';

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


  @override
  Widget build(BuildContext context) {
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
              child: Column(
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
                      await CommonFunction().pickImageVideoFile(true,false,context).then((value){
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
                      if(isVideo) {
                        await CommonFunction().pickImageVideoFile(
                            false, true, context).then((value) {
                          // context.pop();
                          // BlocProvider.of<FileSelectionBloc>(context).add(FileSelectionRefreshEvent((value),isPhoto:0));
                        });
                      }
                      else{
                        await CommonFunction().pickImageVideoFile(
                            true, true, context).then((value) {
                          // context.pop();
                          // BlocProvider.of<FileSelectionBloc>(context).add(FileSelectionRefreshEvent((value),isPhoto:0));
                        });
                      }
                    },
                  ),
                ],
              ),
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
                    context.push('/incidentTypeScreen');
                    // open bottomsheet or dropdown for selection
                  },
                  child: Row(
                    children: [
                      Text(StringHelper.terrorist,
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
                SvgPicture.asset(ImageHelper.imageEnableToggle)
              ],
            ),

            const SizedBox(height: 20),

            // Add Title
            Text(StringHelper.addTitle, style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              hintText: StringHelper.enterTitle, isPassword: false, textController: titleController,

            ),

            const SizedBox(height: 10),

            // Details
            Text("Details", style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
            CommonTextFieldWidget(
              maxLines: 2,
              hintText: StringHelper.enterIncidentDetails, isPassword: false, textController: detailController,

            ),

            const SizedBox(height: 30),

            // Post Button
            CustomButton(text: StringHelper.post, onTap: (){})

          ],
        ),
      ),
    );
  }
}
