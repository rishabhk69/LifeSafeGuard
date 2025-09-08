import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/constants/app_styles.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';
import 'package:video_player/video_player.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final PageController _pageController = PageController();
  final List<String> videoUrls = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
    "https://sample-videos.com/video123/mp4/720/sample_1mb.mp4",
  ];

  int currentIndex = 0;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo(currentIndex);
  }

  void _initializeVideo(int index) {
    _videoController = VideoPlayerController.network(videoUrls[index])
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    _videoController.pause();
    _videoController.dispose();
    _initializeVideo(index);
  }

  @override
  void dispose() {
    _videoController.pause();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: videoUrls.length,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Video Player
                Center(
                  child: _videoController.value.isInitialized && currentIndex == index
                      ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                      : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

                // Overlay (Like TikTok UI)
                Positioned(
                  top: 20,
                  right: 16,
                  child: IconButton(
                      icon:  Icon(Icons.more_horiz),color: Colors.white, onPressed: () {
                    locator<DialogService>().showCommonDialog(context, Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            child: Text(StringHelper.filter,style: MyTextStyleBase.headingStyleLight,),
                            onPressed: (){
                              context.pop();
                              context.pop();
                              context.push('/filterScreen');
                            },
                           ),
                          Divider(),
                          TextButton(
                            child: Text(StringHelper.incidentDetails,style: MyTextStyleBase.headingStyleLight,),
                            onPressed: (){
                              context.pop();
                              context.push('/incidentDetails');
                            },
                          ),
                        ],
                      ),
                    ));
                  },),
                ),
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: Column(
                    children: [
                      SvgPicture.asset(ImageHelper.messageIc,
                        fit: BoxFit.scaleDown,
                        height: 35,
                        width: 35,),
                      Text('20.3k',style: GoogleFonts.poppins(
                       fontWeight: FontWeight.w400,
                        color: ColorConstant.whiteColor
                      ),),
                      SizedBox(height: 20),
                      SvgPicture.asset(ImageHelper.sendIc,
                        fit: BoxFit.scaleDown,
                        height: 35,
                        width: 35,),

                    ],
                  ),
                ),

                // Caption / User info
                Positioned(
                  bottom: 30,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Row(
                     children: [
                       SizedBox(
                         width: 40,
                         height: 40,
                         child: CircleAvatar(
                           backgroundImage:
                           NetworkImage("https://i.pravatar.cc/100"), // User profile
                           radius: 25,
                         ),
                       ),
                       addWidth(5),
                       Text('Samarthy',style: GoogleFonts.poppins(
                           fontWeight: FontWeight.w400,
                           fontSize: 14,
                           color: ColorConstant.whiteColor
                       ),)

                     ],
                      ),
                      addHeight(5),
                      Text('Bom Blast',style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorConstant.whiteColor
                      ),),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(ImageHelper.locationIc),
                          addWidth(5),
                          Text(
                            "Manek Chowk",
                            style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorConstant.whiteColor
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(ImageHelper.timerIc),
                          addWidth(5),
                          Text(
                            "23 JAN, 2025  06:23pm",
                            style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorConstant.whiteColor
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
