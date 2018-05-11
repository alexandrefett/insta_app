import 'package:insta_app/model';
class StandardResponse {
  String message;
  String status;
  dynamic data;

  StandardResponse({this.message, this.status, this.data});

  StandardResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'status': status,
        'data': data
      };
}