library tuto_service;

import 'package:angular/angular.dart';
import 'step.dart';
import 'failed.dart';
import 'dart:html';

@NgInjectableService()
class TutoService {
  String get name => "tuto";

  void start(List<Step> steps) {
    var lastRunningTestIdx = window.localStorage["lastRunningTestIdx"] != null ? int.parse(window.localStorage["lastRunningTestIdx"], onError: (_) => 0) : 0;
    execTestsSteps(steps, lastRunningTestIdx);
  }

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
      window.localStorage["lastRunningTestIdx"] = index.toString();
      failed = true;
      if (e is Failed) {
        assertionFailed.add(e.cause);
      } else {
        assertionFailed.add("Error: " + e.toString());
      }
    } finally {
      step.executed = true;
      step.passed = !failed;
      step.errors = assertionFailed;
    }
  }

}
