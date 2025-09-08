class SignUpModel {
  String? message;
  String? userId;

  SignUpModel({this.message, this.userId});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userId'] = this.userId;
    return data;
  }
}
