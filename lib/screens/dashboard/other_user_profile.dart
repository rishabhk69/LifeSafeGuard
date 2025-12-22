import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/api/model/main/profile_model.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/app_config.dart';

class OtherUserProfileDialog extends StatefulWidget {

  IncidentsModel incidentsModel;

  OtherUserProfileDialog(this.incidentsModel);

  @override
  State<OtherUserProfileDialog> createState() => _OtherUserProfileDialogState();
}

class _OtherUserProfileDialogState extends State<OtherUserProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: ColorConstant.scaffoldColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: (){
                    Navigator.pop(context);
                  }
                ),
              ),

              // 🔹 Profile Image
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  AppConfig.IMAGE_BASE_URL +
                      (widget.incidentsModel.profilePic ?? ""),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Name
              Text(
                widget.incidentsModel.userName ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // // 🔹 Phone
              // Text(
              //   widget.incidentsModel.phone ?? "",
              //   style: const TextStyle(color: Colors.grey, fontSize: 14),
              // ),

              const SizedBox(height: 4),

              // 🔹 Incident count
              Text(
                "${widget.incidentsModel.media?.length } incidents",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              (widget.incidentsModel.media ?? []).isEmpty
                  ? const Text("No incidents available.")
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: widget.incidentsModel.media?.length,
                itemBuilder: (context, index) {
                  final item = widget.incidentsModel.media![index];
                  return buildItem(item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(Media item) {
    var isVideo = (item.name??"").toLowerCase().contains("mp4");
    return isVideo
        ? Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                AppConfig.IMAGE_BASE_URL +
                    (item.thumbnail ?? ""),
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: SvgPicture.asset(ImageHelper.playCircle),
        ),
      ],
    )
        : item.name!.isEmpty
        ? const Icon(Icons.image)
        : Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                AppConfig.IMAGE_BASE_URL +
                    (item.name ?? ""),
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: SvgPicture.asset(ImageHelper.photoIcWhite),
        ),
      ],
    );
  }
}
