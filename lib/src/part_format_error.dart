class PartFormatError implements Exception {
  final String message;
  PartFormatError(String pointer)
      : message = "Invalid json-pointer part: $pointer";
}
