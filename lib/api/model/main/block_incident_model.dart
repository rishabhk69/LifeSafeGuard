class BlockIncidentModel {
  String? status;
  String? incidentId;
  List<Media>? media;
  bool? isVideo;

  BlockIncidentModel({this.status, this.incidentId, this.media, this.isVideo});

  BlockIncidentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    incidentId = json['incidentId'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    isVideo = json['isVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['incidentId'] = this.incidentId;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['isVideo'] = this.isVideo;
    return data;
  }
}

class Media {
  bool? isDeleted;
  String? name;
  Null? thumbnail;

  Media({this.isDeleted, this.name, this.thumbnail});

  Media.fromJson(Map<String, dynamic> json) {
    isDeleted = json['isDeleted'];
    name = json['name'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
