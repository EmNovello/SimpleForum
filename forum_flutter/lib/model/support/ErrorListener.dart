abstract class ErrorListener {
  void errorNetworkOccurred(String message);

  void errorNetworkGone();
}

class BasicErrorListener extends ErrorListener {
  @override
  void errorNetworkGone() {}

  @override
  void errorNetworkOccurred(String message) {
    print(message);
  }
}