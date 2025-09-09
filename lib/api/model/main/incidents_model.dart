class IncidentsModel {
  String? incidentId;
  String? userId;
  String? userName;
  String? category;
  bool? isVideo;
  String? profilePic;
  List<String>? mediaUrls;
  String? time;
  Location? location;

  IncidentsModel(
      {this.incidentId,
        this.userId,
        this.userName,
        this.category,
        this.isVideo,
        this.profilePic,
        this.mediaUrls,
        this.time,
        this.location});

  IncidentsModel.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    userId = json['userId'];
    userName = json['userName'];
    category = json['category'];
    isVideo = json['isVideo'];
    profilePic = json['profilePic'];
    mediaUrls = json['mediaUrls'].cast<String>();
    time = json['time'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
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
    data['mediaUrls'] = this.mediaUrls;
    data['time'] = this.time;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

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
