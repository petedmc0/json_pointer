class BadRouteError implements Exception {
  final String message;
  BadRouteError(String pointer)
      : message = "Error while traversing object allong: $pointer";
}
