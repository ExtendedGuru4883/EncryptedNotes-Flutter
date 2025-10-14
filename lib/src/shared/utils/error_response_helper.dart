class ErrorResponseHelper {
  static String parseErrorResponse(Map<String, dynamic> responseJson) {
    if (responseJson.containsKey('errorMessage')) {
      return (responseJson['errorMessage'] as String);
    } else if (responseJson.containsKey('errors')) {
      String message = '';
      final errors = responseJson['errors'] as Map<String, dynamic>;

      errors.forEach((field, messages) {
        for (String error in List<String>.from(messages)) {
          message += '$error\n';
        }
      });

      message = message.substring(0, message.length - 1);
      return (message);
    } else {
      throw FormatException('Can\'t parse error response');
    }
  }
}
