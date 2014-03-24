library tuto_controller;

import 'package:angular/angular.dart';

@NgController(selector: '[log-ctrl]', publishAs: 'logCtrl')
class LogController {

  List<String> logs = new List();
  var _privateLogs = "AAA";
}