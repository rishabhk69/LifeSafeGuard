import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:untitled/constants/app_utils.dart';

import '../../constants/app_config.dart';

 class MainService {
   final Dio _dio;

   MainService(this._dio);

  @GET(AppConfig.profile)
  // Future<LoginModel> getProfile(@Header("Content-Type") String contentType);
  //
  // @GET(AppConfig.requestOtp)
  // Future<dynamic> getLogin(@Header("Content-Type") String contentType);

   Future<dynamic> getLogin(String phone) async {
     try {
       final response = await _dio.post(
         AppConfig.requestOtp,
         data: {
           'phone':phone
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
