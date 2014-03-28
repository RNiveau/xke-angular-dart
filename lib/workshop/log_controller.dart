library log_controller;

import 'package:angular/angular.dart';

import 'log.dart';
import 'mock_service_log.dart';

@NgController(selector: '[log-ctrl]', publishAs: 'logCtrl')
class LogController {

  List<Log> logs = new List();

  Map<String, bool> status = {"200": true, "404": true, "500": true};
  
//  Map<String, bool> methods = {"GET": true, "POST": true, "PUT": true, "DELETE":true};
  
  LogController() {
    logs = MockServiceLog.getLogs();
  }
}
