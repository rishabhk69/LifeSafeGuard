class SettingModel {
  String? appVersion;
  String? instagram;
  String? facebook;
  String? x;
  String? aboutUs;

  SettingModel(
      {this.appVersion, this.instagram, this.facebook, this.x, this.aboutUs});

  SettingModel.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    x = json['x'];
    aboutUs = json['aboutUs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appVersion'] = this.appVersion;
    data['instagram'] = this.instagram;
    data['facebook'] = this.facebook;
    data['x'] = this.x;
    data['aboutUs'] = this.aboutUs;
    return data;
  }
}
