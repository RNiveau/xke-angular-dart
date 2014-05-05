library truncate_filter;

import 'package:angular/angular.dart';

@Formatter(name:"truncate")
class TruncateFilter {
  String call(String url) {
    if (url.length > 12)
      return url.substring(0, 12) + "...";
    return url;
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
