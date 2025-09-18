class CommentsModel {
  String? incidentId;
  String? commentId;
  String? userId;
  String? userName;
  String? profilePicURL;
  String? comment;
  String? time;

  CommentsModel(
      {this.incidentId,
        this.commentId,
        this.userId,
        this.userName,
        this.profilePicURL,
        this.comment,
        this.time});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    incidentId = json['incidentId'];
    commentId = json['commentId'];
    userId = json['userId'];
    userName = json['userName'];
    profilePicURL = json['profilePicURL'];
    comment = json['comment'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incidentId'] = this.incidentId;
    data['commentId'] = this.commentId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['profilePicURL'] = this.profilePicURL;
    data['comment'] = this.comment;
    data['time'] = this.time;
    return data;
  }
}
