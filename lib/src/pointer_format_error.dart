class PointerFormatError implements Exception {
  final String message;
  PointerFormatError(String pointer)
      : message = "Invalid json-pointer: $pointer";
}
