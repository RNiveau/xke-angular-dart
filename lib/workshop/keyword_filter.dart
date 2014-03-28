library keyword_filter;

import 'package:angular/angular.dart';

@NgFilter(name: "keyword")
class TruncateFilter {
  List call(urls) {
    if (urls is Iterable) {
      // If there is nothing checked, treat it as "everything is checked"
      return nothingChecked ? recipeList.toList() : recipeList.where((i) =>
          filterMap[i.category] == true).toList();
    }
  }
}
