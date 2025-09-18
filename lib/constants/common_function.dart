import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:video_compress/video_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../common/locator/locator.dart';
import '../localization/language_constants.dart';

class CommonFunction{
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? _time;
  XFile? selectedFile;
  XFile? updatedFile;



  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  String dateConvertMMMFormat(String date) {
    if(date.isEmpty){
      return '';
    }
    else{
      DateTime parsedDate = DateTime.parse(date.toString());
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(parsedDate);
      print(formatted);
      return formatted;
    }
  }

  dynamic selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!)
              .copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },);

    if (picked_s != null  ) {
      _time = "${picked_s.hour}:${picked_s.minute}";
      return _time;
    }
  }

  Future<XFile> pickImage(String type) async {
   try{
     if(type == 'camera') {
       image = await picker.pickImage(source: ImageSource.camera,
           imageQuality: 70,
           maxHeight: 1000,
           maxWidth: 800);
       return image!;
     } else {
       image = await picker.pickImage(source: ImageSource.gallery ,imageQuality: 70,
           maxHeight: 1000,
           maxWidth: 800);
       return image!;
     }

   }catch(e){
     debugPrint(e.toString());
   }
   return image!;
  }


  Future<DateTime?> selectDatePicker(BuildContext context, {bool? isFirstEnable}) async {
    DateTime? selectedDate;

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: isFirstEnable ==true ? DateTime.now():DateTime(1950, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        return selectedDate;
    }
    return selectedDate;
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  bool isSameDay(DateTime? a, DateTime? b) {

    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }


  bool calculateExpire(String date) {
    final now = DateTime.now();
    final futureDate = DateTime(now.year, now.month, now.day + 15);
    var parsedDate = DateTime.parse(date);
    final aDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    return aDate.isBefore(futureDate);

  }

  Future<XFile?> pickImageVideoFile(
      bool isPhoto, bool isFromGallery, BuildContext context) async {
    try {
      if (isPhoto) {
        // ---- PHOTO CASE ----
        selectedFile = await picker.pickImage(
          source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        );

        if (selectedFile != null) {
          // check size
          if (getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).contains('mb')) {
            var size = getFileSizeString(bytes: File(selectedFile!.path).lengthSync())
                .replaceAll('mb', '');
            if (int.parse(size) > 100) {
              locator<ToastService>().show(
                  getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb') ?? "");
              return null;
            }
          }
          return selectedFile;
        }
      } else {
        // ---- VIDEO CASE ----
        selectedFile = await picker.pickVideo(
          source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        );
        if (selectedFile != null) {
            return selectedFile; // fallback
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in pickImageVideoFile: $e");
      }
    }
    return null;
  }


  compressVideo(XFile file) async {
    final MediaInfo? response = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    if (response != null && response.path != null) {
      locator<DialogService>().hideLoader();
      return XFile(response.path!);
    }
  }

  Future<void> requestCameraPermission() async {
    // Request the camera permission
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      // Permission is granted
    } else if (status.isDenied) {
      openAppSettings();
      // Permission is denied
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied
      openAppSettings();
    }
  }

  Future<File> getThumbnail(XFile file) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      file.path,
      quality: 50, // 0-100 (higher is better quality, bigger file)
      position: -1, // default is -1 (first frame). You can pass seconds (e.g., 2)
    );
    return thumbnailFile;

  }

  Future<Placemark?> getPlacemarkFromCurrentLocation() async {
    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // permission denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // permanently denied
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocoding
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      return placemarks.first;
    }

    return null; // not found
  }


  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      } else {
        return "No address available";
      }
    } catch (e) {
      return "Error: $e";
    }
  }


}

class LocationData {
  final String? city;
  final String? state;
  final double latitude;
  final double longitude;

  LocationData({this.city, this.state, required this.latitude, required this.longitude});
}

Future<LocationData?> getLocationData() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }
  if (permission == LocationPermission.deniedForever) return null;

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Get address info
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    return LocationData(
      city: place.locality,
      state: place.administrativeArea,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  return null;
}


