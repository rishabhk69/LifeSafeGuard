class BlockedListModel {
  String? incidentId;
  String? isVideo;
  String? status;
  List<Media>? media;

  BlockedListModel({this.incidentId, this.isVideo, this.status, this.media});

  BlockedListModel.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    isVideo = json['isVideo'];
    status = json['status'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incidentId'] = this.incidentId;
    data['isVideo'] = this.isVideo;
    data['status'] = this.status;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  bool? isDeleted;
  String? name;
  String? thumbnail;

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
