class CommonModel {
  String? message;
  String? state;
  int? status;
  dynamic data;

  CommonModel({this.message, this.state, this.status, this.data});

  CommonModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    state = json['state'];
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['state'] = this.state;
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
