import 'dart:convert';

class JwtHelper {
  static String parseUsername(String jwt) {
    final paylaod = jwt.substring(jwt.indexOf('.')+1, jwt.lastIndexOf('.'));
    final normalizedBase64Payload = base64Url.normalize(paylaod);
    final payloadBytes = base64Decode(normalizedBase64Payload);
    final parsedPayload = utf8.decode(payloadBytes);
    final payloadJson = jsonDecode(parsedPayload) as Map<String, dynamic>;
    return payloadJson['name'];
  }
}
