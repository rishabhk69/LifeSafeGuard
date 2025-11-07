class IncidentTypeModel {
  List<Icons>? icons;

  IncidentTypeModel({this.icons});

  IncidentTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['icons'] != null) {
      icons = <Icons>[];
      json['icons'].forEach((v) {
        icons!.add(new Icons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.icons != null) {
      data['icons'] = this.icons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Icons {
  String? incidentType;
  String? imageURL;

  Icons({this.incidentType, this.imageURL});

  Icons.fromJson(Map<String, dynamic> json) {
    incidentType = json['incidentType'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incidentType'] = this.incidentType;
    data['imageURL'] = this.imageURL;
    return data;
  }
}
