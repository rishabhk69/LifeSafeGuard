
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

  Future<Result<dynamic>> getLogin(String data) async {
    final service = MainService(await dio);
    return safeCall(service.getLogin(data));
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

    Future<Result<dynamic>> verifyOtp(String phone,String otp) async {
    final service = MainService(await dio);
    return safeCall(service.verifyOtp(phone,otp));
  }

    Future<Result<dynamic>> agreementData() async {
    final service = MainService(await dio);
    return safeCall(service.agreementData());
  }

}
