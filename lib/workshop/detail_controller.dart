library detail_controller;

import 'package:angular/angular.dart';
import 'dart:async';

import 'log.dart';


@Controller(
    selector: '[detail-ctrl]',
    publishAs: 'detailCtrl')
class DetailController {
  
  Log log;
  
  DetailController(Http _http, RouteProvider _routeProvider) {
    
  }
  
}

