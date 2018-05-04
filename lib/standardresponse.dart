import 'package:insta_app/model';
class StandardResponse {
  final String message;
  final String status;
  final Account data;

  StandardResponse({this.message, this.status, this.data});

  factory StandardResponse.fromJson(Map<String, dynamic> json) {
    return new StandardResponse(
      message: json['message'],
      status: json['status'],
      data: Account.fromJson(json['data'])
    );
  }
  }