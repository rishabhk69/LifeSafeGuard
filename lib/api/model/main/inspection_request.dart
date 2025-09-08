class InspectionRequestModel {
  int? id;
  String? name;
  int? sectionId;
  String? answer;
  String? comment;
  String? defect;

  InspectionRequestModel({this.id, this.name, this.sectionId, this.answer,this.comment,this.defect});

  InspectionRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sectionId = json['section_id'];
    answer = json['answer'];
    comment = json['comment'];
    defect = json['defect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['section_id'] = this.sectionId;
    data['answer'] = this.answer;
    data['comment'] = this.comment;
    data['defect'] = this.defect;
    return data;
  }
}