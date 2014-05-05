library logs_service;

import 'package:angular/angular.dart';
import 'dart:async';

import 'log.dart';

@Injectable()
class LogsService {

  Map<String, Log> logs = new Map();
  
  LogsService(Http http) {
      Future.wait([http.get("apache-log.json").then((HttpResponse httpResponse) {
        for (Map m in httpResponse.data) {
          Log l = new Log.fromJsonMap(m);          
          logs.putIfAbsent(l.id, () => l);
        }
      })]);
    }
  
  Log getLogById(String id) {
    return logs[id];
  }
  

}
