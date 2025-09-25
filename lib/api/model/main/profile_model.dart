class ProfileModel {
  int? starRanking;
  String? userId;
  String? userName;
  String? fisrtName;
  String? lastName;
  String? phone;
  String? profilePhotoUrl;
  String? totalIncidents;
  List<Incidents>? incidents;

  ProfileModel(
      {this.starRanking,
        this.userId,
        this.userName,
        this.fisrtName,
        this.lastName,
        this.phone,
        this.profilePhotoUrl,
        this.totalIncidents,
        this.incidents});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    starRanking = json['starRanking'];
    userId = json['userId'];
    userName = json['userName'];
    fisrtName = json['fisrtName'];
    lastName = json['lastName'];
    phone = json['phone'];
    profilePhotoUrl = json['profilePhotoUrl'];
    totalIncidents = json['totalIncidents'];
    if (json['incidents'] != null) {
      incidents = <Incidents>[];
      json['incidents'].forEach((v) {
        incidents!.add(new Incidents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['starRanking'] = this.starRanking;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['fisrtName'] = this.fisrtName;
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

class Incidents {
  String? incidentId;
  int? viewCount;
  String? category;
  String? isVideo;
  String? time;
  String? title;
  String? desc;
  IncidentLocation? incidentLocation;
  List<Media>? media;
  String? commentCount;

  Incidents(
      {this.incidentId,
        this.viewCount,
        this.category,
        this.isVideo,
        this.time,
        this.title,
        this.desc,
        this.incidentLocation,
        this.media,
        this.commentCount});

  Incidents.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    viewCount = json['viewCount'];
    category = json['category'];
    isVideo = json['isVideo'];
    time = json['time'];
    title = json['title'];
    desc = json['desc'];
    incidentLocation = json['incidentLocation'] != null
        ? new IncidentLocation.fromJson(json['incidentLocation'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incidentId'] = this.incidentId;
    data['viewCount'] = this.viewCount;
    data['category'] = this.category;
    data['isVideo'] = this.isVideo;
    data['time'] = this.time;
    data['title'] = this.title;
    data['desc'] = this.desc;
    if (this.incidentLocation != null) {
      data['incidentLocation'] = this.incidentLocation!.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['commentCount'] = this.commentCount;
    return data;
  }
}

class IncidentLocation {
  dynamic latitude;
  dynamic longitude;

  IncidentLocation({this.latitude, this.longitude});

  IncidentLocation.fromJson(Map<String, dynamic> json) {
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

class Media {
  bool? isMediaDeleted;
  String? name;

  Media({this.isMediaDeleted, this.name});

  Media.fromJson(Map<String, dynamic> json) {
    isMediaDeleted = json['isMediaDeleted'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMediaDeleted'] = this.isMediaDeleted;
    data['name'] = this.name;
    return data;
  }
}
