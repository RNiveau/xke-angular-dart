library truncate_filter;

import 'package:angular/angular.dart';

@Formatter(name: 'truncate')
class TruncateFilter {
  String call(String url){
    return url.length >= 12 ? "${url.substring(0, 12)}..." : url;
  }
}

@Formatter(name:"statusFilter")
class StatusFilter {
  List call(List logs, Map<String, bool> filterMap) {
    if (logs is Iterable && filterMap is Map) {
       return logs.where((i) => filterMap[i.status] == true).toList();
    }
    return [];
  }
}

@Formatter(name:"methodFilter")
class MethodFilter {
  List call(List logs, Map filterMap) {
    if (logs is Iterable && filterMap is Map) {
       return logs.where((i) => filterMap[i.method] == true).toList();
    }
    return [];
  }
}