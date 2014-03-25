import 'dart:html';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import '../lib/tuto/tuto_module.dart';
import 'log_controller.dart';

class WorkshopModule extends Module {
  WorkshopModule() {
    type(LogController);
  }
}

void main() {
  // Write your code here
  ngBootstrap(module: new WorkshopModule());
  
  // Don't touch this =====
  tutoBootstrap();
  // ======================
  String toto = "toto";

}
