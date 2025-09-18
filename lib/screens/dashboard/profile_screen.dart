import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(
        onTap: (){
          context.push("/blockedIncidents");
        },
        showAction: true,
        isMainBar: true,
        // widgets: [Icon(Icons.verified, color: Colors.blue),],
        title: 'nisha.mukhi.123',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile Image + Name + Stats
            Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          'https://picsum.photos/200?random=8'), // Replace with actual image
                    ),
                    Positioned(
                        top: 3,
                        right: 1,
                        child: SvgPicture.asset(ImageHelper.editOrange)),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: (){
                    context.push('/signupScreen');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Nisha Mukhi",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      addWidth(5),
                      SvgPicture.asset(ImageHelper.editGrey)
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "+91 7878976532",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  "103 incidents",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Grid of Posts
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 images per row
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 9,
              // Number of posts
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://picsum.photos/200?random=$index",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
