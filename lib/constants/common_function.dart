import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:light_compressor/light_compressor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';

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

  bool isPastDay(String date , String mainDate) {
    //date.split("-").last+"-"+date.split("-")[1]+"-"+date.split("-").first
    DateTime a = DateTime.parse(date.split("-").reversed.join("-"));
    DateTime b = DateTime.parse(mainDate);
    if (a == null || b == null) {
      return false;
    }
    print(a.isBefore(b!));
    return a.isBefore(b!);

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
    if (isPhoto) {
      if (isFromGallery) {
        selectedFile = await picker.pickImage(source: ImageSource.gallery);
        if (getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).contains('mb')) {
          var size =
          getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).replaceAll('mb', '');
          if (int.parse(size) > 100) {
            locator<ToastService>().show(getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb')??"");
          } else {
            return selectedFile;
          }
        }
        else{
          return selectedFile;
        }

      } else {
        try{
          selectedFile = await picker.pickImage(source: ImageSource.camera);
        }
        catch(e){
          if (kDebugMode) {
            print(e);
          }
        }
        if (getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).contains('mb')) {
          var size =
          getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).replaceAll('mb', '');
          if (int.parse(size) > 100) {
            locator<ToastService>().show(getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb')??"");
          } else {
            return selectedFile;
          }
        }
        else{
          return selectedFile;
        }
      }
    }
    else {
      if (isFromGallery) {
        selectedFile = await picker.pickVideo(source: ImageSource.gallery);
        if (getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).contains('mb')) {
          var size =
          getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).replaceAll('mb', '');
          if (int.parse(size) > 100) {
            locator<ToastService>().show(getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb')??"");
          } else {
            return selectedFile;
          }
        }
        else{
          return selectedFile;
        }
      } else {
        try{
          selectedFile = await picker.pickVideo(source: ImageSource.camera);
          locator<DialogService>().showLoader(message: 'Compressing');
          // final LightCompressor _lightCompressor = LightCompressor();
          // final dynamic response = await _lightCompressor.compressVideo(
          //   path: selectedFile!.path,
          //   videoQuality: VideoQuality.very_low,
          //   isMinBitrateCheckEnabled: false,
          //   video: Video(videoName: selectedFile!.name),
          //   android: AndroidConfig(isSharedStorage: true, saveAt: SaveAt.Movies),
          //   ios: IOSConfig(saveInGallery: false),
          // );
          // if (response is OnSuccess) {
            locator<DialogService>().hideLoader();
            XFile file =  XFile(selectedFile!.path);
            locator<DialogService>().hideLoader();
            selectedFile = file;
          // }
        }
        catch(e){
          if (kDebugMode) {
            requestCameraPermission();
          }
        }
        if (getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).contains('mb')) {
          var size =
          getFileSizeString(bytes: File(selectedFile!.path).lengthSync()).replaceAll('mb', '');
          if (int.parse(size) > 100) {
            locator<ToastService>().show(getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb')??"");
          } else {
            return selectedFile;
          }
        }
        else{
          return selectedFile;
        }
      }
    }
    return null;
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



}