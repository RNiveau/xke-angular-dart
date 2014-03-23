library tuto_controller;

import 'package:angular/angular.dart';
import 'step.dart';
import 'failed.dart';
import 'tuto_service.dart';


@NgController(selector: '[tuto-ctrl]', publishAs: 'tutoCtrl')
class TutoController {
  String get name => "tuto";

  List<Step> _steps = new List();

  TutoService _tutoService;

  TutoController(this._tutoService) {
    _steps.add(new Step("Initialisation de l'application",
        "view/views/tutorial-step-initialisation.html",
        "view/views/tutorial-solution-initialisation.html", () {
      try {
        new Toto();
      } catch (e) {
        throw new Failed("tptp");
      }
    }));

    _steps.add(new Step("Le two-way data binding",
        "view/views/tutorial-step-two-way-binding.html",
        "view/views/tutorial-solution-two-way-binding.html", () {}));

    _steps.add(new Step("Création d'un contrôleur",
        "view/views/tutorial-step-creation-controleur.html",
        "view/views/tutorial-solution-creation-controleur.html", () {}));
    
    _steps.add(new Step("Mise en forme des logs",
        "view/views/tutorial-step-mise-en-forme-log.html",
        "view/views/tutorial-solution-mise-en-forme-log.html", () {}));

//    _steps.add(new Step("Tronquer les URL",
//        "view/views/tutorial-step-trunc-long-url.html",
//        "view/views/tutorial-solution-trunc-long-url.html", () {}));
//
//    _steps.add(new Step("Filtrer les logs par mots clés",
//        "view/views/tutorial-step-filtrer-log.html",
//        "view/views/tutorial-solution-filtrer-log.html", () {}));
//
//    _steps.add(new Step("Filtrer les logs par statuts et verbes HTTP",
//        "view/views/tutorial-step-filter-by-status-and-methods.html",
//        "view/views/tutorial-solution-filter-by-status-and-methods.html", () {}));
//    
//    _steps.add(new Step("Requêter le backend",
//        "view/views/tutorial-step-requete-backend.html",
//        "view/views/tutorial-solution-requete-backend.html", () {}));
//
//    _steps.add(new Step("Utiliser le routeur",
//        "view/views/tutorial-step-routeur.html",
//        "view/views/tutorial-solution-routeur.html", () {}));
//
//    _steps.add(new Step("Afficher le détail d'un log",
//        "view/views/tutorial-step-log-details.html",
//        "view/views/tutorial-solution-log-details.html", () {}));
//
//    _steps.add(new Step("Bonus : Créer une directive",
//        "view/views/tutorial-step-directive.html",
//        "view/views/tutorial-solution-directive.html", () {}));

    _tutoService.execTestsSteps(steps, 0);
  }

  List<Step> get steps => _steps;

}
