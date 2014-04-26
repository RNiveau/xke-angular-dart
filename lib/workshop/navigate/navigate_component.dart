library navigate;

import 'package:angular/angular.dart';

@Component(
    selector: 'navigate',
    templateUrl: 'packages/xke_angular_dart/workshop/navigate/navigate_component.html',
    cssUrl: 'packages/xke_angular_dart/workshop/navigate/navigate_component.css',
    publishAs: 'cmp'
)
class NavigateComponent {

  @NgTwoWay('status')
  var status;

  @NgTwoWay('methods')
  var methods;

  @NgTwoWay('query')
  String query;

}