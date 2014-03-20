library tuto_module;

import 'package:angular/angular.dart';
import 'tuto_controller.dart';
import 'dart:html';

class MyTutoModule extends Module {
  MyTutoModule() {
    type(TutoController);
  }
}


void tutoBootstrap() {
  ngBootstrap(module: new MyTutoModule(), element:querySelector('#tutorial'));
}