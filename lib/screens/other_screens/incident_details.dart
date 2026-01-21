import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/common_function.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/localization/fitness_localization.dart';



class IncidentDetails extends StatefulWidget {
  dynamic incidentData;


  IncidentDetails(this.incidentData);

  @override
  State<IncidentDetails> createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {


  IncidentsModel? incidentsModel;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        incidentsModel = widget.incidentData;
      });
    });
  }

  getUserId()async{
   await AppUtils().getUserId().then((value) {
      setState(() {
        userId = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        actions: [
          incidentsModel?.userId ==  userId ? SizedBox():
          TextButton(
            onPressed: () {
              context.push('/takeAction',extra:
                incidentsModel
              );
            },
            child: Text(
              GuardLocalizations.of(context)!.translate("takeAction") ?? "",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          )
        ],
        title: Text(
          GuardLocalizations.of(context)!.translate("incidentDetails") ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Section
            SizedBox(
              height: 250,
              width: double.infinity,
              child: incidentsModel?.location?.latitude != null && incidentsModel?.location?.longitude != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              (incidentsModel?.location?.latitude ?? 0.0).toDouble(),
                              (incidentsModel?.location?.longitude ?? 0.0).toDouble(),
                            ),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("incident_location"),
                              position: LatLng(
                                (incidentsModel?.location?.latitude ?? 0).toDouble(),
                                (incidentsModel?.location?.longitude ?? 0).toDouble(),
                              ),
                              infoWindow: InfoWindow(
                                title: incidentsModel?.title ?? "Incident",
                                snippet: incidentsModel?.address ?? "",
                              ),
                            ),
                          },
                          zoomControlsEnabled: true,
                        ),

                        if (incidentsModel?.isHideLocation??false) // your condition
                          Positioned.fill(
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Map hidden for your role',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if(incidentsModel?.isHideLocation==false)
                    Positioned(
                        left: 10,
                        bottom: 30,
                        child: InkWell(
                            onTap: (){
                              CommonFunction().openGoogleMaps((incidentsModel?.location?.latitude??0.0).toDouble(),
                                (incidentsModel?.location?.longitude??0.0).toDouble(),);
                            },
                            child: SvgPicture.asset(ImageHelper.redirectIc))),
                  ],
                ),
              )
                  : const Center(
                child: Text("Location not available"),
              ),
            ),


            const SizedBox(height: 20),

            // Info rows
            Row(
              children: [
                SvgPicture.asset(ImageHelper.threeDCube,height: 20,width: 20,),
                // const Icon(Icons.warning_amber_rounded,
                //     color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                 Text(
                  "${GuardLocalizations.of(context)!.translate("type") ?? ""} - ${incidentsModel?.category??""}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(ImageHelper.location,height: 20,width: 20,),
                // const Icon(Icons.location_on, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    incidentsModel?.address??"",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(ImageHelper.time,height: 20,width: 20,color: ColorConstant.primaryColor,),
                const SizedBox(width: 8),
                Text(
                  CommonFunction().formatLocal(incidentsModel?.time??""),
                  // incidentsModel?.time??"",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if((incidentsModel?.title??"").isNotEmpty)
            // Title
             Text(
              GuardLocalizations.of(context)!.translate("title") ?? "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if((incidentsModel?.title??"").isNotEmpty)
            Text(
              incidentsModel?.title??"",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Incident Details
            if((incidentsModel?.description??"").isNotEmpty)
             Text(
              GuardLocalizations.of(context)!.translate("incidentDetails") ?? "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if((incidentsModel?.description??"").isNotEmpty)
            Text(
              incidentsModel?.description??"",
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      )
    );
  }
}
