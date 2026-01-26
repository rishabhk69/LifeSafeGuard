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
  String? thumbnail;
  String? description;
  String? title;
  dynamic commentCount;
  Location? location;
  bool? isReportedAnonymously;
  bool? isHideLocation;

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
        this.thumbnail,
        this.title,
        this.commentCount,
        this.description,
        this.city,
        this.state,
        this.isReportedAnonymously,
        this.isHideLocation,
        this.location});

  IncidentsModel.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    userId = json['userId'];
    userName = json['userName'];
    category = json['category'];
    isVideo = json['isVideo'];
    thumbnail = json['thumbnail'];
    profilePic = json['profilePhotoUrl'];
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
    isHideLocation = json['isHideLocation'];
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
    data['thumbnail'] = this.thumbnail;
    data['profilePhotoUrl'] = this.profilePic;
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
    data['isHideLocation'] = this.isHideLocation;
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

class Media {
  bool? isMediaDeleted;
  String? name;
  String? thumbnail;

  Media({this.isMediaDeleted, this.name, this.thumbnail});

  Media.fromJson(Map<String, dynamic> json) {
    isMediaDeleted = json['isMediaDeleted'];
    thumbnail = json['thumbnail'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMediaDeleted'] = this.isMediaDeleted;
    data['name'] = this.name;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
