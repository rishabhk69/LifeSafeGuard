class QuestionsDetail {
  int? id;
  int? sectionId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Section? section;

  QuestionsDetail(
      {this.id,
        this.sectionId,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.section});

  QuestionsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectionId = json['section_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    section =
    json['section'] != null ? new Section.fromJson(json['section']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['section_id'] = this.sectionId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.section != null) {
      data['section'] = this.section!.toJson();
    }
    return data;
  }
}

class Section {
  int? id;
  String? name;

  Section({this.id, this.name});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}