library tuto_module;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'tuto_controller.dart';
import 'tuto_service.dart';
import 'step_provider.dart';
import 'dart:html';

class MyTutoModule extends Module {
  MyTutoModule() {
    type(TutoController);
    type(TutoService);
    type(StepProvider);
  }
}

void tutoBootstrap() {
  (applicationFactory()
      ..addModule(new MyTutoModule())
      ..selector('#tutorial'))
      .run();
}