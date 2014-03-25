library mock;

import '../lib/log.dart';

class MockServiceLog {

  static List<Log> getLogs() {
    List<Log> logs = new List();

    logs.add(new Log.fromJsonMap({
      "id": "1",
      "method": "GET",
      "status": "200",
      "message": "OK",
      "url": "http://my/site/name/for/fun/and/filtering/demonstration/ok.html",
      "date": "2013-01-01 00:00:00"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "2",
      "method": "GET",
      "status": "200",
      "message": "OK",
      "url": "http://my/site/name/for/fun/and/filtering/demonstration/ok.html",
      "date": "2013-01-01 00:01:00"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "3",
      "method": "DELETE",
      "status": "404",
      "message": "NOT FOUND!",
      "url": "http://notfound.html",
      "date": "2013-01-01 00:00:10"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "4",
      "method": "POST",
      "status": "500",
      "message": "PROBLEM SIR?",
      "url": "http://troll.html",
      "date": "2013-01-01 00:03:10"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "5",
      "method": "DELETE",
      "status": "200",
      "message": "OK",
      "url": "http://ok.html",
      "date": "2013-01-01 00:05:10"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "6",
      "method": "PUT",
      "status": "500",
      "message": "PROBLEM SIR?",
      "url": "http://troll.html",
      "date": "2013-01-01 01:04:00"
    }));
    logs.add(new Log.fromJsonMap({
      "id": "7",
      "method": "POST",
      "status": "404",
      "message": "NOT FOUND!",
      "url": "http://notfound.html",
      "date": "2013-01-01 01:05:00"
    }));
    return logs;
  }

}
