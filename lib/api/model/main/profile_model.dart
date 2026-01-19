import 'package:untitled/api/model/main/incidents_model.dart';

class ProfileModel {
  int? starRanking;
  String? userId;
  String? userName;
  String? firstName;
  String? lastName;
  String? phone;
  String? profilePhotoUrl;
  String? totalIncidents;
  List<IncidentsModel>? incidents;

  ProfileModel(
      {this.starRanking,
        this.userId,
        this.userName,
        this.firstName,
        this.lastName,
        this.phone,
        this.profilePhotoUrl,
        this.totalIncidents,
        this.incidents});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    starRanking = json['starRanking'];
    userId = json['userId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    profilePhotoUrl = json['profilePhotoUrl'];
    totalIncidents = json['totalIncidents'];
    if (json['incidents'] != null) {
      incidents = <IncidentsModel>[];
      json['incidents'].forEach((v) {
        incidents!.add(new IncidentsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['starRanking'] = this.starRanking;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['profilePhotoUrl'] = this.profilePhotoUrl;
    data['totalIncidents'] = this.totalIncidents;
    if (this.incidents != null) {
      data['incidents'] = this.incidents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

