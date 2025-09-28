import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:untitled/constants/app_utils.dart';

import '../../constants/app_config.dart';
import '../../main.dart';

 class MainService {
   final Dio _dio;

   MainService(this._dio);

  @GET(AppConfig.profile)
  // Future<LoginModel> getProfile(@Header("Content-Type") String contentType);
  //
  // @GET(AppConfig.requestOtp)
  // Future<dynamic> getLogin(@Header("Content-Type") String contentType);

   Future<dynamic> getLogin(String phone,bool type) async {
     try {
       final response = await _dio.post(
         AppConfig.requestOtp,
         data: {
           'phone':phone,
           'isRegistering':!type,
         },

       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getIncidents({int? offset, int? size}) async {
     try {
       final response = await _dio.get(
         AppConfig.getIncidents,
         queryParameters: {
           'offset':offset,
           'size' :size
         },
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getProfile({int? offset, int? size, String? userId}) async {
     try {
       final response = await _dio.get(
         "${AppConfig.getProfile}/${userId}",
         queryParameters: {
           'offset':offset,
           'size' :size
         },
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getComments({int? offset, int? size,String? incidentId}) async {
     try {
       final response = await _dio.get(
         "${AppConfig.getIncidents}/$incidentId/comments",
         queryParameters: {
           'offset':offset,
           'size' :size
         },
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getSignUp({
     String? firstName,
     String? lastName,
     String? userName,
     File? profilePhoto,
   }) async {
     String token = await AppUtils().getToken();

     try {
       final formData = FormData.fromMap({
         "firstName": firstName,
         "lastName": lastName,
         "userName": userName,
         if (profilePhoto != null)
           "profilePhoto": await MultipartFile.fromFile(
             profilePhoto.path,
             filename: profilePhoto.path.split('/').last,
           ),
       });

       final response = await _dio.post(
         AppConfig.signup,
         data: formData,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "multipart/form-data",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }


   Future<dynamic> verifyOtp(String phone,String otp) async {
     try {
       final response = await _dio.post(
         AppConfig.verifyOtp,
         data: {
           "phone": phone,
           "otp": otp
         },
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> postIncidents({String? title,
     String? description,
     String? category,
     String? latitude,
     String? city,
     String? state,
     String? userId,
     String? longitude,
     String? address,
     String? pincode,
     String? time,
     bool? reportAnonymously,
     bool? isCameraUpload,
     bool? isVideo,
     bool? isEdited,
     List<File>? files}) async {
     try {
       String token = await AppUtils().getToken();

       final formData = FormData.fromMap({
         "title": title,
         "description": description,
         "category": category,
         "userLatitude": latitude,
         "userLongitude": longitude,
         "incidentLatitude": latitude,
         "incidentLongitude": longitude,
         "isReportedAnonymously": reportAnonymously,
         "isCameraUpload": isCameraUpload,
         "city": city,
         "state": state,
         "isEdited": isEdited,
         "userId": userId,
         "isVideo": isVideo,
         "address": address,
         "pincode": pincode,
         "time": time,
         "isMediaDeleted": false,
         if (files != null && files.isNotEmpty)
           "files": await Future.wait(
             files.map((file) async => await MultipartFile.fromFile(
               file.path,
               filename: file.path.split('/').last,
             )),
           ),});


       final response = await _dio.post(
         AppConfig.postIncidents,
         data: formData,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "multipart/form-data",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }


   Future<dynamic> blockIncident({String? title,
     String? incidentId,
      List<String>? urls,
     String? userId,
     String? description,}) async {
     try {
       String token = await AppUtils().getToken();

       final response = await _dio.post(
         "${AppConfig.postIncidents}/$incidentId/block",
         data:{
           "incidentId": incidentId,
           "incidentBlockerId": userId,
           "title": title,
           "description": description,
           "mediaUrls": urls,
           "blockAt": currentDate
         },
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             // HttpHeaders.contentTypeHeader: "multipart/form-data",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> agreementData() async {
     try {
       final response = await _dio.get(
         AppConfig.userAgreement,
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }


 }
