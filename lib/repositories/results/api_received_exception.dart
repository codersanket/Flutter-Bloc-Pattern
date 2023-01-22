class ApiErrorReceivedException implements Exception {
  final String bodyString;

  ApiErrorReceivedException(this.bodyString);
}
