library router;

import 'package:angular/angular.dart';

void routeInitializer(Router router, RouteViewFactory views) {
  views.configure({
    '/': ngRoute(
        path: '/',
        view: 'view-list.html', defaultRoute : true)
  });
}