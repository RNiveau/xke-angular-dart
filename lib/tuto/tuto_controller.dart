library tuto_controller;

import 'dart:js';
import 'dart:async';
import 'package:angular/angular.dart';
import 'step.dart';
import 'failed.dart';
import 'tuto_service.dart';
import 'step_provider.dart';


@NgController(selector: '[tuto-ctrl]', publishAs: 'tutoCtrl')
class TutoController {
  TutoService _tutoService;
  StepProvider _stepProvider;

  List<Step> _steps;

  TutoController(this._tutoService, this._stepProvider) {
    _steps = _stepProvider.steps;
    _tutoService.start(_steps);

    new Timer(new Duration(milliseconds: 300), () {
      context['hljs'].callMethod('initHighlighting');
    });
  }

  List<Step> get steps => _steps;
}
