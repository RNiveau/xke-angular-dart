library truncate_filter;

import 'package:angular/angular.dart';

@NgFilter(name:"truncate")
class TruncateFilter {
  String call(String url) {
    if (url.length > 12)
      return url.substring(0, 12) + "...";
    return url;
  }
}

@NgFilter(name:"statusFilter")
class StatusFilter {
  List call(List logs, Map<String, bool> filterMap) {
    if (logs is Iterable && filterMap is Map) {
       return logs.where((i) => filterMap[i.status] == true).toList();
    }
  }
}