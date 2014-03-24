library step;


class Step {
  String title;
  String detailTemplateName;
  String solutionTemplateName;
  var _testFunction;

  bool _opened = null;

  bool passed = false;
  bool executed = false;
  List<String> errors = new List();
    
  Step(String this.title, String this.detailTemplateName, String this.solutionTemplateName, var this._testFunction);
  
  get testFunction => _testFunction;
  
  bool isActive() {
      return !this.passed && this.executed;
  }
  
  String getFirstError() => errors.length != 0 ? errors.first : "";

  bool get opened => _opened == null ? isActive() : _opened;

  setOpened(bool _opened) {
    this._opened = _opened;
  }
  
}