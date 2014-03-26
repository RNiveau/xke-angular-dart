library step_provider;

import 'dart:async';
import 'dart:html';
import 'step.dart';
import 'failed.dart';
import 'dart:mirrors';
import 'package:angular/angular.dart';

import '../../web/main.dart';
import '../workshop/log_controller.dart';
import '../workshop/log.dart';
import '../workshop/mock_service_log.dart';
import '../workshop/truncate_filter.dart';

@NgInjectableService()
class StepProvider {
  List<Step> _steps = new List();

  List<Step> get steps => _steps;

  StepProvider() {
    init();
  }


  void init() {
    _steps.add(new Step("Initialisation de l'application",
        "tuto/steps/tutorial-step-initialisation.html",
        "tuto/steps/tutorial-solution-initialisation.html", () {
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
        "tuto/steps/tutorial-step-two-way-binding.html",
        "tuto/steps/tutorial-solution-two-way-binding.html", () {

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
        "tuto/steps/tutorial-step-creation-controleur.html",
        "tuto/steps/tutorial-solution-creation-controleur.html", () {

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

      HttpRequest request = new HttpRequest();
      request.open("GET", "main.dart", async: false);
      request.send();
      RegExp regExp = new RegExp("WorkshopModule\\(\\)\\s*{");
      ok(regExp.hasMatch(request.responseText),
          "Le module WorkshopModule doit contenir un constructeur");

      regExp = new RegExp("type\\(\\s*LogController\\s*\\)\\s*;");
      ok(regExp.hasMatch(request.responseText),
          "Le constructeur doit déclarer le type LogController");

      regExp = new RegExp(
          "ngBootstrap\\(\\s*module\\s*:\\s*new\\s*WorkshopModule\\(\\)\\s*\\)\\s*;");
      ok(regExp.hasMatch(request.responseText),
          "L'applicatin doit être bootstrapper avec le module WorkshopModule");

      bool found = querySelectorAll('#angular-app')[0].text.contains(
          "http://my/site/name/for/fun/and/filtering/demonstration/ok.html");
      ok(found, "Les logs doivent être affichés dans la page");
    }));

    _steps.add(new Step("Mise en forme des logs",
        "tuto/steps/tutorial-step-mise-en-forme-log.html",
        "tuto/steps/tutorial-solution-mise-en-forme-log.html", () {

      var repeat = querySelector("[ng-repeat]");
      ok(repeat != null,
          "Utiliser la directive ng-repeat pour parcourir les logs et les afficher dans le tableau"
          );
      String attr = repeat.attributes["ng-repeat"];
      ok(new RegExp("\\s*\\w\\s+in\\s+logCtrl.logs").hasMatch(attr),
          "La directive ng-repeat doit parcourir l'attribut logs du controller");
      ok(querySelectorAll("#angular-app tr") != null && querySelectorAll(
          "#angular-app tr").length == 7, "Afficher les logs dans le tableau");

      multiple([_stringExistInLog(querySelector(
          "#angular-app tr td:nth-child(1)"), MockServiceLog.getLogs()[0]),
          _stringExistInLog(querySelector("#angular-app tr td:nth-child(2)"),
          MockServiceLog.getLogs()[0]), _stringExistInLog(querySelector(
          "#angular-app tr td:nth-child(3)"), MockServiceLog.getLogs()[0]),
          _stringExistInLog(querySelector("#angular-app tr td:nth-child(4)"),
          MockServiceLog.getLogs()[0]), _stringExistInLog(querySelector(
          "#angular-app tr td:nth-child(5)"), MockServiceLog.getLogs()[0])],
          "Le tableau doit afficher la date, l'url, le verbe, le statut et le message de chaque log"
          );
      bool found = querySelectorAll('#angular-app')[0].text.contains("[{");
      ok(!found, "Le JSON brut ne doit plus être affiché");

    }));

    _steps.add(new Step("Tronquer les URL",
        "tuto/steps/tutorial-step-trunc-long-url.html",
        "tuto/steps/tutorial-solution-trunc-long-url.html", () {

      try {
        new TruncateFilter();
      } catch (error) {
        fail("La classe TruncateFilter doit exister");
      }

      var obj;
      try {
        ClassMirror classMirror = reflectClass(TruncateFilter);
        List<InstanceMirror> metadata = classMirror.metadata;
        obj = metadata.first.reflectee;
      } catch (error) {
        fail(
            "Le filter 'TruncateFilter' doit avoir l'annotation décrivant le filter");
      }
      ok(obj != null,
          "Le filter 'TruncateFilter' doit avoir l'annotation décrivant le filter"
          );
      ok(obj is NgFilter,
          "Le filter 'TruncateFilter' doit avoir l'annotation @NgFilter");
      ok(obj.name != null,
          "L'annotation @NgFilter doit avoir un name spécifique");
      ok(obj.name == "truncate",
          "L'annotation @NgFilter doit avoir le name 'truncate'");

      try {
        TruncateFilter truncateFilter = new TruncateFilter();
        truncateFilter.call(null);
      } catch (e) {
        fail("Le filter doit posséder une méthode call qui prend un String en paramètre");
      }
  

    }));

    //    _steps.add(new Step("Filtrer les logs par mots clés",
    //        "tuto/steps/tutorial-step-filtrer-log.html",
    //        "tuto/steps/tutorial-solution-filtrer-log.html", () {}));
    //
    //    _steps.add(new Step("Filtrer les logs par statuts et verbes HTTP",
    //        "tuto/steps/tutorial-step-filter-by-status-and-methods.html",
    //        "tuto/steps/tutorial-solution-filter-by-status-and-methods.html", () {}));
    //
    //    _steps.add(new Step("Requêter le backend",
    //        "tuto/steps/tutorial-step-requete-backend.html",
    //        "tuto/steps/tutorial-solution-requete-backend.html", () {}));
    //
    //    _steps.add(new Step("Utiliser le routeur",
    //        "tuto/steps/tutorial-step-routeur.html",
    //        "tuto/steps/tutorial-solution-routeur.html", () {}));
    //
    //    _steps.add(new Step("Afficher le détail d'un log",
    //        "tuto/steps/tutorial-step-log-details.html",
    //        "tuto/steps/tutorial-solution-log-details.html", () {}));
    //
    //    _steps.add(new Step("Bonus : Créer une directive",
    //        "tuto/steps/tutorial-step-directive.html",
    //        "tuto/steps/tutorial-solution-directive.html", () {}));

  }

  void ok(bool testPassed, String msg) {
    if (!testPassed) {
      throw new Failed(msg);
    }
  }

  void fail(msg) {
    ok(false, msg);
  }

  void multiple(List<bool> testArray, String msg) {
    var successfulTest = 0;
    testArray.forEach((bool fl) {
      if (fl) successfulTest++;
    });
    if (successfulTest < testArray.length) {
      throw new Failed(msg + " (" + successfulTest.toString() + "/" +
          testArray.length.toString() + ")");
    }
  }

  bool _stringExistInLog(Element element, Log log) {
    if (element == null) return false;
    String text = element.text;
    if (text == null) return false;
    return log.id == text || log.message == text || log.method == text ||
        log.status == text || log.url == text;
  }

}
