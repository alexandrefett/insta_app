import 'package:insta_app/model';
class StandardResponse {
  final String message;
  final String status;
  final Map<String, dynamic> data;

  StandardResponse({this.message, this.status, this.data});

  StandardResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        status = json['status'],
        data = json['data'];

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'status': status,
        'data': data
      };
}