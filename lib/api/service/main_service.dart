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

   Future<dynamic> deleteAccount(String userId,String reason) async {
     try {
       final response = await _dio.post(
         '$userId${AppConfig.deleteAccount}',
         data: {
           "userId": userId,
           "reason": reason,
           "deletedBy": "admin"
         },

       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> deleteIncident(String incidentId,String reason) async {
     try {
       final response = await _dio.post(
         "${AppConfig.getProfile}/delete",
         data: {
           "reason": reason,
           "incidentId": incidentId
         },

       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getIncidents({int? offset, int? size,String? city,String? type}) async {
     String token = await AppUtils().getToken();
     try {
       final response = await _dio.get(
         AppConfig.getIncidents,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             'language': "English",
           },
         ),
         queryParameters: {
           'offset':offset,
           'size' :size,
           'city' :city,
           'type' :type,
         },
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getProfile({int? offset, int? size, String? userId}) async {
     String token = await AppUtils().getToken();
     try {
       final response = await _dio.get(
         "${AppConfig.getProfile}/$userId",
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             'language': "English",
           },
         ),
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

   Future<dynamic> updateProfile({
     String? firstName,
     String? lastName,
     String? userId,
     File? profilePhoto,
   }) async {
     String token = await AppUtils().getToken();

     try {
       final formData = FormData.fromMap({
         "firstName": firstName,
         "lastName": lastName,
         "userId": userId,
         if (profilePhoto != null)
           "profilePhoto": await MultipartFile.fromFile(
             profilePhoto.path,
             filename: profilePhoto.path.split('/').last,
           ),
       });

       final response = await _dio.post(
         AppConfig.profileUpdate,
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


   Future<dynamic> verifyOtp(String phone,String otp,bool isRegistering) async {
     try {
       final response = await _dio.post(
         AppConfig.verifyOtp,
         data: {
           "phone": phone,
           "otp": otp,
           "isRegistering": isRegistering,
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
             'language': "English",
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
       final formData = FormData.fromMap({
         "incidentId": incidentId,
         "incidentBlockerId": userId,
         "title": title,
         "description": description,
         "attachments": urls ?? [],
       });
       final response = await _dio.post(
         "${AppConfig.postIncidents}/$incidentId/block",
         data:formData,
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


   Future<dynamic> spamIncident({
     String? incidentId,
     String? userId,}) async {
     try {
       String token = await AppUtils().getToken();
       final response = await _dio.post(
         "${AppConfig.postIncidents}/$incidentId/spam",
         data:{
           "incidentId": incidentId,
           "userId": userId,
         },
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "application/json",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }


   Future<dynamic> getCityList() async {
     try {
       String token = await AppUtils().getToken();
       final response = await _dio.get(
         AppConfig.cityList,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "application/json",
             'language': "English",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> getTypeList() async {
     try {
       String token = await AppUtils().getToken();
       final response = await _dio.get(
         AppConfig.typeList,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "application/json",
             'language': "English",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }


   Future<dynamic> settingData() async {
     try {
       String token = await AppUtils().getToken();
       final response = await _dio.get(
         AppConfig.getSetting,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "application/json",
             'language': "English",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> instructionData() async {
     try {
       String token = await AppUtils().getToken();
       final response = await _dio.get(
         AppConfig.getInstructions,
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             HttpHeaders.contentTypeHeader: "application/json",
             'language': "English",
           },
         ),
       );

       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> postComment({String? comment,
     String? incidentId,
     String? userId,
     String? lastName,
     String? userName,
     String? firstName,}) async {
     try {
       String token = await AppUtils().getToken();
      Map<String,dynamic> request = {
        "incidentId": incidentId,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "comment": comment,
        "timestamp": currentDate
      };
       final response = await _dio.post(
         AppConfig.postComments,
         data:request,
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

   Future<dynamic> getBlockedIncidents(int? offset, int? size) async {
     String token = await AppUtils().getToken();
     String userId = await AppUtils().getUserId();
     try {
       final response = await _dio.get(
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.contentTypeHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             'App-Version': '1.0.0',
             'OS-Version': Platform.isAndroid ? '18.3': Platform.operatingSystem.toString(),
             'Device-Type': Platform.isAndroid ? 'Android':'IOS',
           },
         ),
         "${AppConfig.getBlockedIncidents}/$userId",
         queryParameters: {
           'offset':offset,
           'size' :size,
           "blockedBy": "User"
         },
         data: {
           "userId": userId,

         }
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }

   Future<dynamic> supportHelp({ String? supportType,
     String? subject,
     String? details,
     String? inqueryType,
     String? name,
     String? number,
     String? email}) async {
     String token = await AppUtils().getToken();
     String userId = await AppUtils().getUserId();
     try {
       final response = await _dio.post(
         options: Options(
           headers: {
             HttpHeaders.acceptHeader: "application/json",
             HttpHeaders.contentTypeHeader: "application/json",
             HttpHeaders.authorizationHeader: "Bearer $token",
             'App-Version': '1.0.0',
             'OS-Version': Platform.isAndroid ? '18.3': Platform.operatingSystem.toString(),
             'Device-Type': Platform.isAndroid ? 'Android':'IOS',
           },
         ),
         AppConfig.support,
         data:{
             "userId": userId,
             "supportType": supportType,
             "subject": subject,
             "details": details,
             "inqueryType": inqueryType,
             "name": name,
             "number": number,
             "email": email
           }
       );
       return response.data;
     } catch (e) {
       rethrow;
     }
   }


 }
