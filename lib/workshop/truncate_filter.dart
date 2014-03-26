library truncate_filter;

import 'package:angular/angular.dart';

@NgFilter(name:"truncate")
class TruncateFilter {
  String call(String url) {
    return url;
  }
}