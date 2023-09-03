class CallStartModel {
  bool? status;
  String? message;
  int? callId;
  String? busyStatus;

  CallStartModel({this.status, this.message, this.callId, this.busyStatus});

  CallStartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    callId = json['call_id'];
    busyStatus = json['busy_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['call_id'] = callId;
    data['busy_status'] = busyStatus;
    return data;
  }
}
