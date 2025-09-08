class SafeguardingModel {
  bool? error;
  String? message;
  String? state;
  int? status;
  Data? data;

  SafeguardingModel(
      {this.error, this.message, this.state, this.status, this.data});

  SafeguardingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    state = json['state'];
    status = json['status'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['state'] = this.state;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? slug;
  String? shortDescription;
  String? description;
  String? metaTitle;
  String? metaDescription;
  int? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.title,
        this.slug,
        this.shortDescription,
        this.description,
        this.metaTitle,
        this.metaDescription,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    description = json['description'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
