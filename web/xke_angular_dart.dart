import 'dart:html';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';
import 'package:angular/routing/module.dart';
import '../lib/tuto/tuto_module.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(AngularController);
  }
}



@NgController(
    selector: '[angular-ctrl]',
    publishAs: 'angularCtrl')
class AngularController {
  AngularController() {
    //fail;
  }
  
  String get name => "appli";
}

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  Injector injector = ngBootstrap(module: new MyAppModule());
  // Don't touch this
  tutoBootstrap();

  
  querySelector("#angular-app");
//  ngProbe (querySelector("#sample_container_id")).injector.instances.values.first is AngularController

  
}
