import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';

class IncidentDetails extends StatefulWidget {
  const IncidentDetails({super.key});

  @override
  State<IncidentDetails> createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                context.push('/takeAction');
              },
              child: Text(
                StringHelper.takeAction,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            )
          ],
          title: Text(
            StringHelper.incidentDetails,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body:  SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      ImageHelper.mapImage, // Replace with Google Map widget if required
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 60,
                      left: 150,
                      child: Column(
                        children: [
                          Text(
                            StringHelper.incidentLocation,
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          SvgPicture.asset(
                            ImageHelper.mapPin, // Replace with your location marker svg
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Info rows
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "Type - Terrorist",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "Manek Chowk",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "23 JAN, 2025 | 06:23pm",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Title
               Text(
                StringHelper.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Bomb Blast at manek chowk",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Incident Details
               Text(
                StringHelper.incidentDetails,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "The bomb blast incident at Manek Chowk was part of a series of coordinated terrorist attacks "
                    "that struck Ahmedabad, Gujarat, on July 26, 2008. Within a span of 70 minutes, 21 bombs "
                    "detonated across various locations in the city, including Manek Chowk, resulting in 56 "
                    "fatalities and injuring over 200 individuals.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        )
      ),
    );
  }
}
