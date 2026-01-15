import 'dart:io';
import 'dart:math';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/video_trimmer.dart';
import 'package:untitled/localization/fitness_localization.dart';
import 'package:url_launcher/url_launcher.dart';
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


  void openGoogleMaps(double lat, double lng) async {
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


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

  String formatLocal(String utcString) {
    if (utcString.isEmpty) {
      return '';
    }
    DateTime utcDateTime =
    DateFormat("dd MMM yyyy hh:mm:ss a").parseUtc(utcString);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat("dd MMM yyyy hh:mm a").format(localDateTime);
  }



  bool calculateExpire(String date) {
    final now = DateTime.now();
    final futureDate = DateTime(now.year, now.month, now.day + 15);
    var parsedDate = DateTime.parse(date);
    final aDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    return aDate.isBefore(futureDate);

  }

  Future<List<XFile>?> pickImageVideoFile(
      bool isPhoto, bool isFromGallery, BuildContext context) async {
    final picker = ImagePicker();
    try {
      if (isPhoto) {
        if (isFromGallery) {
          final pickedFiles = await picker.pickMultiImage(imageQuality: 70);

          if (pickedFiles.isNotEmpty) {
            if (pickedFiles.length > 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You can select a maximum of 5 images."),
                ),
              );
            }

            final limitedFiles = pickedFiles.take(5).toList();

            for (final file in limitedFiles) {
              if (_isFileTooLarge(file, context)) {
                return null;
              }
            }
            return limitedFiles;
          }
        } else {
          // only one photo from camera
          final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
          if (pickedFile != null) {
            if (_isFileTooLarge(pickedFile, context)) return null;
            return [pickedFile];
          }
        }
      } else {
        // video (gallery or camera)
        final pickedFile = await picker.pickVideo(
          source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        );
        if (pickedFile != null) {
          return [pickedFile];
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in pickImageVideoFile: $e");
      }
    }
    return null;
  }


  Future<DateTime?> getImageCaptureTime(XFile image) async {
    final bytes = await File(image.path).readAsBytes();
    final tags = await readExifFromBytes(bytes);

    if (tags.containsKey('EXIF DateTimeOriginal')) {
      final value = tags['EXIF DateTimeOriginal']!.printable;
      // Format: "2023:08:25 14:32:10"
      return DateTime.parse(
        value.replaceFirst(':', '-')
            .replaceFirst(':', '-')
            .replaceFirst(' ', 'T'),
      );
    }
    return null;
  }


  bool _isFileTooLarge(XFile file, BuildContext context) {
    final sizeString =
    getFileSizeString(bytes: File(file.path).lengthSync()).toLowerCase();
    if (sizeString.contains('mb')) {
      final size = double.tryParse(sizeString.replaceAll('mb', '').trim()) ?? 0;
      if (size > 100) {
        locator<ToastService>().show(
          getTranslated(context, 'imageSizeShouldNotBeMoreThan100Mb') ?? "",
        );
        return true;
      }
    }
    return false;
  }


  compressVideo(XFile file, BuildContext context) async {
    // 1. Open trimming screen and wait for result
    final File? trimmedFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModernTrimDialog(file: File(file.path)),
      ),
    );

    // 2. If user cancelled or trimming failed
    if (trimmedFile == null) return null;

    locator<DialogService>().showLoader(message: GuardLocalizations.of(context)!.translate('loading') ?? "");
    // 3. Compress trimmed video
    final MediaInfo? response = await VideoCompress.compressVideo(
      trimmedFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );

    if (response != null && response.path != null) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        locator<DialogService>().hideLoader();
      });

      return XFile(response.path!);
    }

    return null;
  }

  Future<File?> saveFileToDevice(File source) async {
    try {
      if (!Platform.isAndroid) {
        // iOS fallback
        final dir = await getApplicationDocumentsDirectory();
        return source.copy('${dir.path}/${basename(source.path)}');
      }

      final Directory downloadsDir =
      Directory('/storage/emulated/0/Download');

      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final String fileName = basename(source.path);
      final String newPath = '${downloadsDir.path}/$fileName';

      final File savedFile = await source.copy(newPath);
      return savedFile;
    } catch (e) {
      print('Video error: $e');
      return null;
    }
  }



  Future<void> requestCameraPermission() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
    } else if (status.isDenied) {
      openAppSettings();
    } else if (status.isPermanentlyDenied) {
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
  final String? postCode;
  final String? address;
  final double latitude;
  final double longitude;

  LocationData({this.city,this.postCode,this.address, this.state, required this.latitude, required this.longitude});
}

Future<LocationData?> getLocationData() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }
  if (permission == LocationPermission.deniedForever) return null;

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    final fullAddress =
        "${place.subLocality}, "
        "${place.locality}, ${place.subAdministrativeArea}, "
        "${place.administrativeArea}, ${place.country}, "
        "${place.postalCode}";
    return LocationData(
      address: fullAddress,
      postCode: place.postalCode,
      city: place.locality,
      state: place.administrativeArea,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  return null;
}



