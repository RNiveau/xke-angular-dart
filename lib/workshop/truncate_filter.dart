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