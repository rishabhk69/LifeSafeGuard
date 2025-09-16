class OtpVerifyModel {
  String? message;
  String? token;
  String? userId;

  OtpVerifyModel({this.message, this.token,this.userId});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['userId'] = this.userId;
    return data;
  }
}
