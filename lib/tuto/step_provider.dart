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
import '../workshop/filters.dart';
import '../workshop/router.dart';

@NgInjectableService()
class StepProvider {
  List<Step> _steps = new List();

  List<Step> get steps => _steps;

  Http _http;

  StepProvider(Http this._http) {
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

      String text = _getTextMain();
      RegExp regExp = new RegExp("WorkshopModule\\(\\)\\s*{");
      ok(regExp.hasMatch(text),
          "Le module WorkshopModule doit contenir un constructeur");

      regExp = new RegExp("type\\s*\\(\\s*LogController\\s*\\)\\s*;");
      ok(regExp.hasMatch(text),
          "Le constructeur du module doit déclarer le type LogController");

      regExp = new RegExp(
          "ngBootstrap\\(\\s*module\\s*:\\s*new\\s*WorkshopModule\\(\\)\\s*\\)\\s*;");
      ok(regExp.hasMatch(text),
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
          "Le filter 'TruncateFilter' doit avoir l'annotation décrivant le filter");
      ok(obj is NgFilter,
          "Le filter 'TruncateFilter' doit avoir l'annotation @NgFilter");
      ok(obj.name != null,
          "L'annotation @NgFilter doit avoir un name spécifique");
      ok(obj.name == "truncate",
          "L'annotation @NgFilter doit avoir le name 'truncate'");

      TruncateFilter truncateFilter = null;
      try {
        truncateFilter = new TruncateFilter();
        truncateFilter.call("unelongueurljustepourtester");
      } catch (e) {
        fail(
            "Le filter doit posséder une méthode call qui prend un String en paramètre et le retourne tronqué à 12 caractères, suivie de '...'"
            );
      }

      ok(truncateFilter.call("shorturl") == "shorturl",
          "Si on passe 'shorturl' en paramètre du filtre, il doit retourner 'shorturl'");
      ok(truncateFilter.call("unelongueurljustepourtester") ==
          "unelongueurl...",
          "Si on passe 'unelongueurljustepourtester' en paramètre du filtre, il doit retourner 'unelongueurl...'"
          );

      String text = _getTextMain();
      RegExp regExp = new RegExp("type\\s*\\(\\s*TruncateFilter\\s*\\)\\s*;");
      ok(regExp.hasMatch(text),
          "Le constructeur du module WorkshopModule doit déclarer le type TruncateFilter"
          );
      ok(querySelector("#angular-app tr").text.contains("..."),
          "Appliquer le filtre dans le template html pour tronquer l'URL des logs");

    }));

    _steps.add(new Step("Filtrer les logs par mots clés",
        "tuto/steps/tutorial-step-filtrer-log.html",
        "tuto/steps/tutorial-solution-filtrer-log.html", () {

      ok(querySelector('#angular-app input[ng-model="query"]') != null,
          "L'attribut ng-model avec la valeur query doit être défini au niveau du champ de recherche"
          );

      InputElement input = querySelector("input");
      input
          ..focus()
          ..dispatchEvent(new TextEvent('textInput', data: "zhkc8fjk"));
      bool found = querySelectorAll('#angular-app')[0].text.contains("zhkc8fjk"
          );
      try {
        ngScope(input).apply("query = ''");
      } catch (e) {
        fail(
            "La valeur du champ de recherche ne doit plus être affichée dans la page");
      }

      ok(!found,
          "La valeur du champ de recherche ne doit plus être affichée dans la page");

      input.value = "";
      input
          ..focus()
          ..dispatchEvent(new TextEvent('textInput', data: "OK"));
      ok(querySelectorAll("#angular-app tr") != null && querySelectorAll(
          "#angular-app tr").length == 3,
          "Les logs doivent être filtrées avec la valeur du champ de recherche");
      ngScope(input).apply("query = ''");
    }));

    _steps.add(new Step("Filtrer les logs par statuts et verbes HTTP",
        "tuto/steps/tutorial-step-filter-by-status-and-methods.html",
        "tuto/steps/tutorial-solution-filter-by-status-and-methods.html", () {

      ngScope(querySelector("input")).apply("query = ''");
      LogController logCtrl = new LogController();
      try {
        logCtrl.status;
      } catch (e) {
        fail("Le controller doit avoir un attribut 'status'");
      }
      ok(logCtrl.status is Map,
          "L'attribut 'status' doit être de type Map<String, bool>");

      ok(logCtrl.status.length == 3,
          "L'attribut 'status' doit contenir les 3 status (200, 404, 500)");

      ok(logCtrl.status["200"] != null && logCtrl.status["404"] != null &&
          logCtrl.status["500"] != null,
          "L'attribut 'status' doit contenir les 3 status (200, 404, 500)");
      List<Element> checkbox = querySelectorAll("input[type=checkbox][ng-model]"
          );

      ok(checkbox != null && (checkbox.length == 3 || checkbox.length == 7),
          "Binder les checkboxs avec la map 'status' du logCtrl");
      try {
        new StatusFilter();
      } catch (e) {
        fail("Créer un filter StatusFilter");
      }

      var obj;
      try {
        ClassMirror classMirror = reflectClass(StatusFilter);
        List<InstanceMirror> metadata = classMirror.metadata;
        obj = metadata.first.reflectee;
      } catch (error) {
        fail(
            "Le filter 'StatusFilter' doit avoir l'annotation décrivant le filter");
      }
      ok(obj != null,
          "Le filter 'StatusFilter' doit avoir l'annotation décrivant le filter");
      ok(obj is NgFilter,
          "Le filter 'StatusFilter' doit avoir l'annotation @NgFilter");
      ok(obj.name != null,
          "L'annotation @NgFilter doit avoir un name spécifique");
      ok(obj.name == "statusFilter",
          "L'annotation @NgFilter doit avoir le name 'statusFilter'");

      StatusFilter filter = new StatusFilter();
      try {
        filter.call(new List(), new Map());
      } catch (e) {
        fail(
            "Le filtrer StatusFilter doit avoir une méthode 'List call(List, Map);'");
      }

      logCtrl.status['404'] = false;
      List logs = filter.call(MockServiceLog.getLogs(), logCtrl.status);
      ok(logs.length == 5,
          "La méthode call doit filtrer les éléments en fonction du status");

      String text = _getTextMain();
      RegExp regExp = new RegExp("type\\s*\\(\\s*StatusFilter\\s*\\)\\s*;");
      ok(regExp.hasMatch(text),
          "Le constructeur du module WorkshopModule doit déclarer le type StatusFilter");

      String ngRepeat = querySelector("tr[ng-repeat]").attributes['ng-repeat'];
      regExp = new RegExp("\\|\\s*statusFilter\\s*:\\s*logCtrl\\.status");
      ok(regExp.hasMatch(ngRepeat),
          "Appliquer le filtre sur les logs dans le ng-repeat. Passer en paramètre du filtre la map de status"
          );

      try {
        logCtrl.methods;
      } catch (e) {
        fail("Le controller doit avoir un attribut 'methods'");
      }
      ok(logCtrl.methods is Map,
          "L'attribut 'methods' doit être de type Map<String, bool>");

      ok(logCtrl.methods.length == 4,
          "L'attribut 'methods' doit contenir les 4 status (GET, POST, PUT, DELETE)");

      ok(logCtrl.methods["GET"] != null && logCtrl.methods["POST"] != null &&
          logCtrl.methods["PUT"] != null && logCtrl.methods["DELETE"] != null,
          "L'attribut 'methods' doit contenir les 4 status (GET, POST, PUT, DELETE)");
      checkbox = querySelectorAll("input[type=checkbox][ng-model]");

      ok(checkbox != null && checkbox.length == 7,
          "Binder les checkboxs avec la map 'methods' du logCtrl");

      try {
        new MethodFilter();
      } catch (e) {
        fail("Créer un filter MethodFilter");
      }

      try {
        ClassMirror classMirror = reflectClass(MethodFilter);
        List<InstanceMirror> metadata = classMirror.metadata;
        obj = metadata.first.reflectee;
      } catch (error) {
        fail(
            "Le filter 'MethodFilter' doit avoir l'annotation décrivant le filter");
      }
      ok(obj != null,
          "Le filter 'MethodFilter' doit avoir l'annotation décrivant le filter");
      ok(obj is NgFilter,
          "Le filter 'MethodFilter' doit avoir l'annotation @NgFilter");
      ok(obj.name != null,
          "L'annotation @NgFilter doit avoir un name spécifique");
      ok(obj.name == "methodFilter",
          "L'annotation @NgFilter doit avoir le name 'methodFilter'");

      MethodFilter methodFilter = new MethodFilter();
      try {
        methodFilter.call(new List(), new Map());
      } catch (e) {
        fail(
            "Le filtrer MethodFilter doit avoir une méthode 'List call(List, Map);'");
      }

      logCtrl.methods['GET'] = false;
      logCtrl.methods['POST'] = false;
      logCtrl.methods['PUT'] = false;
      logs = MockServiceLog.getLogs();
      logs = methodFilter.call(MockServiceLog.getLogs(), logCtrl.methods);
      ok(logs.length == 2,
          "La méthode call doit filtrer les éléments en fonction de la méthode");

      regExp = new RegExp("type\\s*\\(\\s*MethodFilter\\s*\\)\\s*;");
      ok(regExp.hasMatch(text),
          "Le constructeur du module WorkshopModule doit déclarer le type MethodFilter");

      ngRepeat = querySelector("tr[ng-repeat]").attributes['ng-repeat'];
      regExp = new RegExp("\\|\\s*methodFilter\\s*:\\s*logCtrl\\.methods");
      ok(regExp.hasMatch(ngRepeat),
          "Appliquer le filtre sur les logs dans le ng-repeat. Passer en paramètre du filtre la map de status"
          );


    }));

    _steps.add(new Step("Requêter le backend",
        "tuto/steps/tutorial-step-requete-backend.html",
        "tuto/steps/tutorial-solution-requete-backend.html", () {
      ngScope(querySelector("input")).apply("query = ''");
      try {
        new LogController(_http);
      } catch (e) {
        fail(
            "Le constructeur du 'LogController' doit prendre en paramètre un service 'Http'"
            );
      }

      LogController logCtrlInstance = null;
      logCtrlInstance = ngProbe(querySelector("#angular-app")).injector.get(
          LogController);
      ok(logCtrlInstance != null,
          "LogController n'existe pas dans l'application");
      ok(logCtrlInstance.logs.length == 291,
          "Charger le fichier 'apache-log.json' et le mapper dans l'attribut 'logs' du controller"
          );

    }));

    _steps.add(new Step("Utiliser le routeur",
        "tuto/steps/tutorial-step-routeur.html",
        "tuto/steps/tutorial-solution-routeur.html", () {
      ngScope(querySelector("input")).apply("query = ''");

      try {
        routeInitializer;
      } catch (e) {
        fail("Créer une fonction 'routeInitializer'");
      }


      Injector injector = ngInjector(querySelector("#angular-app"));
      List list = reflect(routeInitializer).function.parameters;
      ok(list.length >= 1 && list[0].type.qualifiedName.toString() ==
          "Symbol(\"route.client.Router\")",
          "Le premier paramètre de la function doit être de type 'Router'");
      ok(list.length > 1 && list[1].type.qualifiedName.toString() ==
          "Symbol(\"angular.routing.RouteViewFactory\")",
          "Le deuxième paramètre de la function doit être de type 'RouteViewFactory'");

      NgRoutingHelper helper = new NgRoutingHelper(null, injector, new Router(),
          new NgApp(querySelector("#angular-app")));
      RouteViewFactory route = new RouteViewFactory(helper);
      try {
        routeInitializer(new Router(), route);
        ok(helper.router.root.getRoute("/") != null,
            "Créer une route '/' qui a pour view 'view-list.html'");
      } catch (e) {
        if (e is Failed) throw e;
      }

      ok(injector.get(RouteInitializerFn) != null,
          "Déclarer la fonction en tant que 'RouteInitializerFn' dans le constructeur du 'WorkshopModule'"
          );

      //      InstanceMirror ins = reflect(ngProbe(querySelector("#angular-app")).injector);
      //      ins = ins;
      //      //ins.type.typeVariables
      //      //reflectClass(ngProbe(querySelector("#angular-dart")).injector).declarations.values.forEach((e) => print(e))
      //      var test = reflect(ngProbe(querySelector("#angular-app")).injector);
      //      var s = MirrorSystem.getSymbol('_providers', test.type.owner);
      //      currentMirrorSystem().libraries
      //      //reflectClass(DynamicInjector).declarations.values.forEach((e) => test.getField(e.simpleName, test.type.owner))))
      //      ins.getField(new Symbol("_providers"));
//      HttpRequest.getString("view-list.html").catchError((e) => error = 
//          "Déplacer le tableau de logs dans le fichier 'view-list.html'").then((e) {
//          });
//        Timer timer = new Timer(new Duration(milliseconds: 1000), (){} );
//        if (error != null)
//          fail(error);
      //        ok(view != null && view.length > 0, ");

      ok(querySelector("ng-view") != null,
          "Insérer la view dans le fichier 'index.html'");

    }));

    //    _steps.add(new Step("Afficher le détail d'un log",
    //        "tuto/steps/tutorial-step-log-details.html",
    //        "tuto/steps/tutorial-solution-log-details.html", () {}));
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

  String _getTextMain({path: "main.dart"}) {
    HttpRequest request = new HttpRequest();
    request.open("GET", path, async: false);
    request.send();
    if (request.status == 404) return null;
    return request.responseText;
  }
}
