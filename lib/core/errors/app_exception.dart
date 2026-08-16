class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please try again.',
  ]);
}

class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'The requested item was not found.',
  ]);
}
