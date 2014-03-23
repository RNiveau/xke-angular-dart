library tuto_controller;

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
    _tutoService.execTestsSteps(steps, 0);
  }

  List<Step> get steps => _steps;
}
