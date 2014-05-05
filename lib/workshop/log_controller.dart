library log_controller;

import 'package:angular/angular.dart';
import 'dart:async';
import 'dart:js';

import 'log.dart';
import 'mock_service_log.dart';

@Controller(selector: '[log-ctrl]', publishAs: 'logCtrl')
class LogController {
  
  Map<String, bool> status = {"200" : true, "404": true, "500": true};
    
  Map<String, bool> methods = {"GET": true, "POST": true, "PUT": true, "DELETE":true};

  List logs = new List();

  String query = "";
  
  LogController(Http http) {
      Future.wait([http.get("apache-log.json").then((HttpResponse httpResponse) {
        for (Map log in httpResponse.data) {
          Log l = new Log.fromJsonMap(log);
          logs.add(l);
        }
      })]);;
    }
  
  void poney() {
    //context['BrowserPonies'].callMethod('start');
  }
}