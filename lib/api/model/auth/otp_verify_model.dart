class OtpVerifyModel {
  String? message;
  String? token;

  OtpVerifyModel({this.message, this.token});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }
}
