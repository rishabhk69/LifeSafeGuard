import 'package:flutter/cupertino.dart';

import '../auth/question_model.dart';

class VehicleInspectionModel {
  String? message;
  String? state;
  int? status;
  List<InspectionData>? data;

  VehicleInspectionModel({this.message, this.state, this.status, this.data});

  VehicleInspectionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    state = json['state'];
    status = json['status'];
    if (json['data'] != null) {
      data = <InspectionData>[];
      json['data'].forEach((v) {
        data!.add(new InspectionData.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['state'] = this.state;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InspectionData {
  int? id;
  String? name;
  int? sectionId;
  Section? section;
  String? answer;
  String? comment;
  String? defect;

  InspectionData({this.id, this.name, this.sectionId, this.section,this.defect,this.comment,this.answer});

  InspectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sectionId = json['section_id'];
    answer = json['answer'];
    comment = json['comment'];
    defect = json['defect'];
    section =
    json['section'] != null ? new Section.fromJson(json['section']) : null;
  }

  Map<String, dynamic> toJson() => {
    "question_id": id,
    "name": name,
    "section_id": sectionId,
    "answer": answer,
    "comment": comment,
    "defect": defect,

  };
  // "section": section?.toJson(),
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['section_id'] = this.sectionId;
//     data['answer'] = this.answer;
//     data['comment'] = this.comment;
//     data['defect'] = this.defect;
//     if (this.section != null) {
//       data['section'] = this.section!.toJson();
//     }
//     return data;
//   }
}
