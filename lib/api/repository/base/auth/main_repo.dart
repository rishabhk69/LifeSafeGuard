
import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../model/auth/login_model.dart';
import '../../../network/result.dart';
import '../../../service/main_service.dart';
import '../base_repository.dart';

@lazySingleton
class MainRepository extends BaseRepository {
  // Future<Result<LoginModel>> getProfile() async =>
  //     safeCall(MainService(await dio).getProfile("application/json"));

  Future<Result<dynamic>> getLogin(String data,bool type) async {
    final service = MainService(await dio);
    return safeCall(service.getLogin(data,type));
  }


  Future<Result<dynamic>> deleteAccount(String data,String reason) async {
    final service = MainService(await dio);
    return safeCall(service.deleteAccount(data,reason));
  }

  Future<Result<dynamic>> getSignUp(
      {String? firstName, String? lastName, String? userName, File? profilePhoto,}) async {
    final service = MainService(await dio);
    return safeCall(service.getSignUp(
      firstName: firstName,
      lastName: lastName,
      profilePhoto: profilePhoto,
      userName: userName
    ));
  }

  Future<Result<dynamic>> getIncidents(
      {int? offset, int? size}) async {
    final service = MainService(await dio);
    return safeCall(service.getIncidents(
      offset: offset,
      size: size
    ));
  }


  Future<Result<dynamic>> getProfile(
      {int? offset, int? size,String? userId}) async {
    final service = MainService(await dio);
    return safeCall(service.getProfile(
      userId: userId,
      offset: offset,
      size: size
    ));
  }

  Future<Result<dynamic>> getComments(
      {int? offset, int? size,String? incidentId}) async {
    final service = MainService(await dio);
    return safeCall(service.getComments(
      offset: offset,
      size: size,
      incidentId: incidentId
    ));
  }

    Future<Result<dynamic>> verifyOtp(String phone,String otp) async {
    final service = MainService(await dio);
    return safeCall(service.verifyOtp(phone,otp));
  }

    Future<Result<dynamic>> postIncidents({String? title,
      String? description,
      String? category,
      String? latitude,
      String? longitude,
      String? city,
      String? state,
      String? userId,
      String? address,
      String? time,
      String? pincode,
      bool? reportAnonymously,
      bool? isCameraUpload,
      bool? isVideo,
      bool? isEdited,
      List<File>? files}) async {
    final service = MainService(await dio);
    return safeCall(service.postIncidents(title: title,
        reportAnonymously: reportAnonymously,
        longitude: longitude,
        latitude: latitude,
        isVideo: isVideo,
        isCameraUpload: isCameraUpload,
        files: files,
        description: description,
        city: city,
        isEdited: isEdited,
        state: state,
        userId: userId,
        address: address,
        pincode: pincode,
        time: time,
        category: category));
  }

    Future<Result<dynamic>> blockIncident({String? title,
      String? description,
      String? incidentId,
      String? userId,
      List<String>? urls}) async {
    final service = MainService(await dio);
    return safeCall(service.blockIncident(title: title,
        incidentId: incidentId,
        urls: urls,
        description: description,
        userId: userId,
       ));
  }

    Future<Result<dynamic>> spamIncident({String? title,
      String? description,
      String? incidentId,
      String? userId,
      List<String>? urls}) async {
    final service = MainService(await dio);
    return safeCall(service.spamIncident(
        incidentId: incidentId,
        userId: userId,
       ));
  }

    Future<Result<dynamic>> postComment({String? firstName,
      String? userName,
      String? lastName,
      String? comment,
      String? incidentId,
      String? userId,
     }) async {
    final service = MainService(await dio);
    return safeCall(service.postComment(
         userName: userName,
        incidentId: incidentId,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
      comment: comment
       ));
  }

    Future<Result<dynamic>> getCityList() async {
    final service = MainService(await dio);
    return safeCall(service.getCityList());
  }

    Future<Result<dynamic>> agreementData() async {
    final service = MainService(await dio);
    return safeCall(service.agreementData());
  }

    Future<Result<dynamic>> getBlockedIncidents(int? offset, int? size) async {
    final service = MainService(await dio);
    return safeCall(service.getBlockedIncidents(offset,size));
  }

}
