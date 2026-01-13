import 'package:untitled/api/model/main/profile_model.dart';


class IncidentsModel {
  String? incidentId;
  String? userId;
  String? userName;
  String? category;
  dynamic isVideo;
  String? profilePic;
  List<Media>? media;
  String? time;
  String? address;
  String? city;
  String? state;
  String? description;
  String? title;
  dynamic commentCount;
  Location? location;
  bool? isReportedAnonymously;

  IncidentsModel(
      {this.incidentId,
        this.userId,
        this.userName,
        this.category,
        this.isVideo,
        this.profilePic,
        this.media,
        this.time,
        this.address,
        this.title,
        this.commentCount,
        this.description,
        this.city,
        this.state,
        this.isReportedAnonymously,
        this.location});

  IncidentsModel.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    userId = json['userId'];
    userName = json['userName'];
    category = json['category'];
    isVideo = json['isVideo'];
    profilePic = json['profilePic'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    time = json['time'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    title = json['title'];
    commentCount = json['commentCount'];
    description = json['description'];
    isReportedAnonymously = json['isReportedAnonymously'];
    location = json['incidentLocation'] != null
        ? new Location.fromJson(json['incidentLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incidentId'] = this.incidentId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['category'] = this.category;
    data['isVideo'] = this.isVideo;
    data['profilePic'] = this.profilePic;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    data['commentCount'] = this.commentCount;
    data['title'] = this.title;
    data['city'] = this.city;
    data['state'] = this.state;
    data['description'] = this.description;
    data['address'] = this.address;
    data['isReportedAnonymously'] = this.isReportedAnonymously;
    if (this.location != null) {
      data['incidentLocation'] = this.location!.toJson();
    }
    return data;
  }
}


class Location {
  dynamic latitude;
  dynamic longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
