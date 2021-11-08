class ParsingException implements Exception {
  /// A message describing the format error.
  final String message;

  /// Creates a new FormatException with an optional error [message].
  const ParsingException([this.message = ""]);

  @override
  String toString() => "FormatException: $message";
}
