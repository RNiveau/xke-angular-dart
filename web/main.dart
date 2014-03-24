import 'dart:html';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import '../lib/tuto/tuto_module.dart';

class WorkshopModule extends Module {

}

void main() {
  // Write your code here
  ngBootstrap();
  
  // Don't touch this =====
  tutoBootstrap();
  // ======================
  String toto = "toto";
  
}
