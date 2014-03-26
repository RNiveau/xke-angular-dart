library log;

import 'dart:convert';

class Log {

  String id;
  String method;
  String status;
  String message;
  String url;
  DateTime date;

  Log(this.id, this.method, this.status, this.message, this.url, String date) {
    this.date = DateTime.parse(date);
  }

  factory Log.fromJsonMap(Map<String, dynamic> json) => new Log(json['id'],
      json['method'], json['status'], json['message'], json['url'], json['date']);

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "method": method,
    "status": status,
    "message": message,
    "url": url,
    "date": date.toString()
  };
  
  String toString() {
    return JSON.encode(this);
  }
}
