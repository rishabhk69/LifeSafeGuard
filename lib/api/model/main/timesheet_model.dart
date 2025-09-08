class TimeSheetModel {
  bool? error;
  String? message;
  String? state;
  int? status;
  Data? data;

  TimeSheetModel(
      {this.error, this.message, this.state, this.status, this.data});

  TimeSheetModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    state = json['state'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  int? userId;
  int? timesheetMonth;
  String? routeNo;
  String? totalAmount;
  dynamic totalDays;
  String? fullName;
  dynamic badgeNo;
  int? isCompleted;
  int? isApproved;
  List<TimesheetData>? timesheetData;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.timesheetMonth,
        this.totalAmount,
        this.totalDays,
        this.routeNo,
        this.fullName,
        this.badgeNo,
        this.isCompleted,
        this.isApproved,
        this.timesheetData,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['fullName'];
    totalAmount = json['total_amount'];
    totalDays = json['total_days'];
    timesheetMonth = json['timesheet_month'];
    routeNo = json['route_no'];
    badgeNo = json['badge_no'];
    isCompleted = json['is_completed'];
    isApproved = json['is_approved'];
    if (json['timesheet_data'] != null) {
      timesheetData = <TimesheetData>[];
      json['timesheet_data'].forEach((v) {
        timesheetData!.add(new TimesheetData.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['user_id'] = this.userId;
    data['total_amount'] = this.totalAmount;
    data['total_days'] = this.totalDays;
    data['timesheet_month'] = this.timesheetMonth;
    data['route_no'] = this.routeNo;
    data['badge_no'] = this.badgeNo;
    data['is_completed'] = this.isCompleted;
    data['is_approved'] = this.isApproved;
    if (this.timesheetData != null) {
      data['timesheet_data'] =
          this.timesheetData!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TimesheetData {
  String? week;
  String? days;
  int? isComplete;
  List<WeekData>? weekData;

  TimesheetData({this.week, this.days, this.isComplete, this.weekData});

  TimesheetData.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    days = json['days'];
    isComplete = json['is_complete'];
    if (json['week_data'] != null) {
      weekData = <WeekData>[];
      json['week_data'].forEach((v) {
        weekData!.add(new WeekData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['week'] = this.week;
    data['days'] = this.days;
    data['is_complete'] = this.isComplete;
    if (this.weekData != null) {
      data['week_data'] = this.weekData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekData {
  String? date;
  String? day;
  int? week;
  bool? isAm;
  dynamic block;
  dynamic pickUp;
  dynamic destination;
  dynamic amount;
  dynamic reason;

  WeekData(
      {this.date,
        this.day,
        this.week,
        this.isAm,
        this.block,
        this.pickUp,
        this.destination,
        this.amount,
        this.reason});

  WeekData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    week = json['week'];
    isAm = json['isAm'];
    block = json['block'];
    pickUp = json['pick_up'];
    destination = json['destination'];
    amount = json['amount'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['week'] = this.week;
    data['isAm'] = this.isAm;
    data['block'] = this.block;
    data['pick_up'] = this.pickUp;
    data['destination'] = this.destination;
    data['amount'] = this.amount;
    data['reason'] = this.reason;
    return data;
  }
}
