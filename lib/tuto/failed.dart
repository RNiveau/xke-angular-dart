library failed;

class Failed implements Exception {
  String cause;
  
  Failed(this.cause);
}