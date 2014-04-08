library detail_controller;

import 'package:angular/angular.dart';
import 'dart:async';

import 'log.dart';

@NgController(selector: '[detail-ctrl]', publishAs: 'detailCtrl')
class DetailController {
  
  Log log;
  
  DetailController(Http http, RouteProvider route) {
    Future.wait([http.get("apache-log.json").then((HttpResponse httpResponse) {
      for (Map mLog in httpResponse.data) {
        Log l = new Log.fromJsonMap(mLog);
        if (l.id == route.parameters['detailId']) {
          log = l;
          break;
        }
      }
    })]);;
    ;
  }
}
