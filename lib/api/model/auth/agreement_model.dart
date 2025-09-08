class AgreementModel {
  String? agreement;
  String? version;

  AgreementModel({this.agreement, this.version});

  AgreementModel.fromJson(Map<String, dynamic> json) {
    agreement = json['agreement'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agreement'] = this.agreement;
    data['version'] = this.version;
    return data;
  }
}
