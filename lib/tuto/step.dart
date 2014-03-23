library step;


class Step {
  String title;
  String detailTemplateName;
  String solutionTemplateName;
  var _testFunction;
  
  bool passed = false;
  bool executed = false;
  List<String> errors = new List();
    
  Step(String this.title, String this.detailTemplateName, String this.solutionTemplateName, var this._testFunction);
  
  get testFunction => _testFunction;
  
  bool isActive() {
      return !this.passed && this.executed;
  }
  
  String getFirstError() => errors.length != 0 ? errors.first : "";

}