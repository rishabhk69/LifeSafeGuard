import 'dart:convert';

class AgreementModel {
  Map<String, dynamic>? agreement;
  String? version;

  AgreementModel({this.agreement, this.version});

  AgreementModel.fromJson(Map<String, dynamic> json) {
    // Decode if it's a string
    if (json['agreement'] is String) {
      agreement = jsonDecode(json['agreement']);
    } else {
      agreement = json['agreement'];
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // Encode back to String if needed
    data['agreement'] = jsonEncode(agreement);
    data['version'] = version;
    return data;
  }
}
