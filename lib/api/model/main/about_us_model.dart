// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) =>
    AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  bool? error;
  String? message;
  String? state;
  int? status;
  Data? data;

  AboutUsModel({
    this.error,
    this.message,
    this.state,
    this.status,
    this.data,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        error: json["error"],
        message: json["message"],
        state: json["state"],
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "state": state,
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? title;
  String? slug;
  String? shortDescription;
  String? description;
  String? metaTitle;
  String? metaDescription;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        shortDescription: json["short_description"],
        description: json["description"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "short_description": shortDescription,
        "description": description,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
