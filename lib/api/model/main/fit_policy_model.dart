class FitPolicyModel {
  String? message;
  String? state;
  int? status;
  List<QuestionData>? data;

  FitPolicyModel({this.message, this.state, this.status, this.data});

  FitPolicyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    state = json['state'];
    status = json['status'];
    if (json['data'] != null) {
      data = <QuestionData>[];
      json['data'].forEach((v) {
        data!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['state'] = this.state;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionData {
  int? id;
  String? question;
  String? commentText;
  int? isCommentOnAnswer;
  dynamic answerVal;
  dynamic remarkVal;

  QuestionData({this.id, this.question, this.commentText, this.isCommentOnAnswer,this.answerVal,this.remarkVal});

  QuestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    commentText = json['comment_text'];
    isCommentOnAnswer = json['is_comment_on_answer'];
    answerVal = json['answerVal'];
    remarkVal = json['remarkVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['comment_text'] = this.commentText;
    data['is_comment_on_answer'] = this.isCommentOnAnswer;
    data['answerVal'] = this.answerVal;
    data['remarkVal'] = this.remarkVal;
    return data;
  }
}
