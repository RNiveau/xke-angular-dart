library detail_controller;

import 'package:angular/angular.dart';
import 'logs_service.dart';

import 'log.dart';

@Controller(selector: '[detail-ctrl]', publishAs: 'detailCtrl')
class DetailController {
  Log log;
   
  DetailController(LogsService logsService, RouteProvider routeProvider) {
    log = logsService.getLogById(routeProvider.parameters['detailId']);
  }

}

