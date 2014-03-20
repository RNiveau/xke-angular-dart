library tuto_controller;

import 'package:angular/angular.dart';
import 'step.dart';


@NgController(
    selector: '[tuto-ctrl]',
    publishAs: 'tutoCtrl')
class TutoController {
  String get name => "tuto";
  
  List<Step> _steps = new List();
  
  TutoController() {
    _steps.add(new Step(
        "Initialisation de l'application", 
        "view/views/tutorial-step-initialisation.html", 
        "view/views/tutorial-solution-initialisation.html", 
        (_) 
        {
            print("plup");
        }
        ));
    _steps.add(new Step("Title2", "template2", "template22", (_)=>print("plup1")));
    
  }
  
  List<Step> get steps => _steps;
  
}
