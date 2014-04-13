import 'dart:html';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(targets: const ['routeInitializer'], override: '*')
import 'dart:mirrors';
import 'package:logging/logging.dart';
import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import '../lib/tuto/tuto_module.dart';
import '../lib/workshop/log_controller.dart';
import '../lib/workshop/detail_controller.dart';
import '../lib/workshop/filters.dart';
import '../lib/workshop/router.dart';

class WorkshopModule extends Module {
  WorkshopModule()  {
    type(LogController);
    type(TruncateFilter);
    type(StatusFilter);
    type(MethodFilter);
    type(DetailController);
    value(RouteInitializerFn, routeInitializer);
    factory(NgRoutingUsePushState,
            (_) => new NgRoutingUsePushState.value(false));
  }
}

void main() {
  // Write your code here
  ngBootstrap(     module   : new WorkshopModule());
  
  // Don't touch this =====
  tutoBootstrap();
}
