library step_provider;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'step.dart';
import 'failed.dart';
import '../../web/main.dart';
import '../../web/log_controller.dart';
import 'dart:mirrors';
import '../log.dart';

@NgInjectableService()
class StepProvider {
  List<Step> _steps = new List();

  List<Step> get steps => _steps;

  StepProvider() {
    init();
  }


  void init() {
    _steps.add(new Step("Initialisation de l'application",
        "view/views/tutorial-step-initialisation.html",
        "view/views/tutorial-solution-initialisation.html", () {
      try {
        new WorkshopModule();
      } catch (e) {
        fail("WorkshopModule is not defined");
      }
      if (!(new WorkshopModule() is Module)) throw new Failed(
          "WorkshopModule is not a Module instance");
      if (querySelector("#angular-app[ng-app]") == null) throw new Failed(
          "ng-app directive missing");

      if (querySelector("#test").text != "Test") throw new Failed(
          "Application n'est pas initialisée");
    }));

    _steps.add(new Step("Le two-way data binding",
        "view/views/tutorial-step-two-way-binding.html",
        "view/views/tutorial-solution-two-way-binding.html", () {

      ok(querySelector('#angular-app input[ng-model="query"]') != null,
          "Ajouter au champ de recherche l'attribut ng-model avec la valeur query");

      querySelector("input")
          ..focus()
          ..dispatchEvent(new TextEvent('textInput', data: "TestDataBinding"));
      bool found = querySelectorAll('#angular-app')[0].text.contains(
          "TestDataBinding");
      querySelector("input").value = "";
      querySelector("input")
          ..focus()
          ..dispatchEvent(new TextEvent('textInput', data: " "));
      querySelector("input").value = "";
      ok(found,
          "La valeur entrée dans le champ de recherche doit être affichée dans la page");
    }));

    _steps.add(new Step("Création d'un contrôleur",
        "view/views/tutorial-step-creation-controleur.html",
        "view/views/tutorial-solution-creation-controleur.html", () {

      var logCtrl;
      try {
        logCtrl = new LogController();
      } catch (error) {
        if (error is TypeError) fail(
            "Le contrôleur 'LogController' n'est pas défini");
        throw error;
      }

      var obj;
      try {
        ClassMirror classMirror = reflectClass(LogController);
        List<InstanceMirror> metadata = classMirror.metadata;
        obj = metadata.first.reflectee;
      } catch (error) {
        fail(
            "Le contrôleur 'LogController' doit avoir l'annotation décrivant le controlleur"
            );
      }

      ok(obj != null,
          "Le contrôleur 'LogController' doit avoir l'annotation décrivant le controlleur"
          );
      ok(obj is NgController,
          "Le contrôleur 'LogController' doit avoir l'annotation @NgController");
      ok(obj.selector != null,
          "L'annotation @NgController doit avoir un selecteur spécifique");
      ok(obj.selector == "[log-ctrl]",
          "L'annotation @NgController doit avoir un selecteur [log-ctrl]");
      ok(obj.publishAs == "logCtrl",
          "L'annotation @NgController doit être publié en tant que 'logCtrl'");

      // This can be used when testing private fields presence ;)
      //   reflectClass(LogController).declarations.keys.forEach((Simbol e) => print(e))
      // and
      //  reflectClass(LogController).declarations.values.forEach((Simbol e) => print(e))

      try {
        logCtrl.logs;
      } catch (error) {
        fail("La proprieté 'logs' n'est pas définie dans le controlleur");
      }
      ok(logCtrl.logs != null, "La proprieté 'logs' ne doit pas être null");
      ok(logCtrl.logs is List, "La proprieté 'logs' doit être un list");



      ok(logCtrl.logs.length == 7 && logCtrl.logs[0] is Log &&
          logCtrl.logs[0].url ==
          "http://my/site/name/for/fun/and/filtering/demonstration/ok.html",
          "Utiliser le MockServiceLog pour injecter les logs dans le controller");

      ok(querySelector('#angular-app[log-ctrl]') != null,
          "Le contrôleur 'LogController' doit être défini au niveau du div #angular-app à l'aide de l'attribut log-ctrl"
          );

//      var file = new File("step_provider.dart");
//        Future<String> finishedReading = file.readAsString(encoding: UTF-8);
//        finishedReading.then((text) => print(text));
      
      bool found = querySelectorAll('#angular-app')[0].text.contains(
          "http://my/site/name/for/fun/and/filtering/demonstration/ok.html");
      ok(found, "Les logs doivent être affichés dans la page");

      
      

    }));

    _steps.add(new Step("Mise en forme des logs",
        "view/views/tutorial-step-mise-en-forme-log.html",
        "view/views/tutorial-solution-mise-en-forme-log.html", () {

    }));

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



  }

  void ok(bool testPassed, String msg) {
    if (!testPassed) {
      throw new Failed(msg);
    }
  }

  void fail(msg) {
    ok(false, msg);
  }

}
