class PostIncidentsModel {
  String? message;
  String? incidentId;
  String? timestamp;
  List<String>? mediaUrls;
  String? city;
  String? state;

  PostIncidentsModel(
      {this.message,
      this.incidentId,
      this.timestamp,
      this.mediaUrls,
      this.city,
      this.state});

  PostIncidentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    incidentId = json['incidentId'];
    timestamp = json['timestamp'];
    mediaUrls = json['mediaUrls'].cast<String>();
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['incidentId'] = this.incidentId;
    data['timestamp'] = this.timestamp;
    data['mediaUrls'] = this.mediaUrls;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}
