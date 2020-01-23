class LeftProjectionException implements Exception {
  final String error;

  LeftProjectionException(this.error);
}

class RightProjectionException implements Exception {
  final String error;

  RightProjectionException(this.error);
}