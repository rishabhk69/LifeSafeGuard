import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/api/model/main/incidents_model.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/strings.dart';

class IncidentDetails extends StatefulWidget {
  dynamic incidentData;


  IncidentDetails(this.incidentData);

  @override
  State<IncidentDetails> createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {


  IncidentsModel? incidentsModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        incidentsModel = widget.incidentData;
      });
    });
  }

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
              SizedBox(
                height: 250,
                width: double.infinity,
                child: incidentsModel?.location?.latitude != null && incidentsModel?.location?.longitude != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        incidentsModel?.location?.latitude??0.0,
                        incidentsModel?.location?.longitude??0.0,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("incident_location"),
                        position: LatLng(
                          incidentsModel?.location?.latitude??0.0,
                          incidentsModel?.location?.longitude??0.0,
                        ),
                        infoWindow: InfoWindow(
                          title: incidentsModel?.title ?? "Incident",
                          snippet: incidentsModel?.address ?? "",
                        ),
                      ),
                    },
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
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
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                   Text(
                    "${StringHelper.type} - ${incidentsModel?.category??""}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
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
                  const Icon(Icons.access_time, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    incidentsModel?.time??"",
                    // "23 JAN, 2025 | 06:23pm",
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
              Text(
                incidentsModel?.title??"",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Incident Details
               Text(
                StringHelper.incidentDetails,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                incidentsModel?.description??"",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        )
      ),
    );
  }
}
