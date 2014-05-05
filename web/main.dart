import 'dart:html';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(targets: const ['routeInitializer'], override: '*')
import 'dart:mirrors';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';
import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import '../lib/tuto/tuto_module.dart';
import '../lib/workshop/log_controller.dart';
import '../lib/workshop/detail_controller.dart';
import '../lib/workshop/filters.dart';
import '../lib/workshop/router.dart';
import '../lib/workshop/navigate/navigate_component.dart';


void main() {
  // Write your code here
  
  // Don't touch this =====
  tutoBootstrap();
}
