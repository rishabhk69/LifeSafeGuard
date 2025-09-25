class PostIncidentsModel {
  String? message;
  String? incidentId;
  String? timestamp;
  List<Media>? media;
  String? city;
  String? state;
  String? address;
  String? time;

  PostIncidentsModel(
      {this.message,
        this.incidentId,
        this.timestamp,
        this.media,
        this.city,
        this.state,
        this.address,
        this.time});

  PostIncidentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    incidentId = json['incidentId'];
    timestamp = json['timestamp'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    city = json['city'];
    state = json['state'];
    address = json['address'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['incidentId'] = this.incidentId;
    data['timestamp'] = this.timestamp;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['city'] = this.city;
    data['state'] = this.state;
    data['address'] = this.address;
    data['time'] = this.time;
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
