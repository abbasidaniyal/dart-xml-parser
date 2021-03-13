class InvalidXMLException implements Exception {
  String message;

  InvalidXMLException(this.message) : super();

  @override
  String toString() => "InvalidXMLException: " + message;
}
