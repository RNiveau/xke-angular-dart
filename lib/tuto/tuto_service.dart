library tuto_service;

import 'package:angular/angular.dart';
import 'step.dart';
import 'failed.dart';

@NgInjectableService()
class TutoService {
  String get name => "tuto";

  List<Step> _steps = new List();

  void execTestsSteps(List<Step> steps, int index) {
    List<String> assertionFailed = new List();

    if (steps.length == index) return;
    Step step = steps[index];
    var test = step.testFunction;
    bool failed = false;

    try {
      test();
      if (index < steps.length) {
        execTestsSteps(steps, 1 + index);
      }
    } catch (e) {
      //          localStorage.lastRunningTestIdx = index;
      failed = true;
      if (e is Failed) {
        assertionFailed.add(e.cause);
      } else {
        assertionFailed.add("Error: " + e.cause);
      }
    } finally {
      step.executed = true;
      step.passed = !failed;
      step.errors = assertionFailed;
    }
  }

}
