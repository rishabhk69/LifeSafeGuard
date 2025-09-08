import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_utils.dart';
import 'app_config.dart';

Future<dynamic> commonUploadFunction(
    Map<String, dynamic> request, String endpoint) async {
  String token = await AppUtils().getToken();
  log("${AppConfig.HOST}$endpoint $token", name: "end");
  try {
    var response = await Dio().post(
      "${AppConfig.HOST}$endpoint",
      data: FormData.fromMap(request),
      options: Options(
        headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "multipart/form-data"
        },
      ),
    );

    if (response.statusCode == 200) {
      return ((response.data));
      // return CommonModel.fromJson((response.data));
    } else {
      return (message: 'Something went wrong');
      // return CommonModel(message: 'Something went wrong');
    }
  } catch (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }
  return null;
  // return CommonModel();
}
