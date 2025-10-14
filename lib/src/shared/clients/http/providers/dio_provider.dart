import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final String? _baseUri = dotenv.env["BASE_URI"];
  if (_baseUri == null) {
    throw Exception('BASE_URI not found in environment variables.');
  }
  final options = BaseOptions(
    baseUrl: _baseUri,
    contentType: 'application/json',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 10),
  );

  final dio = Dio(options);

  ref.onDispose(dio.close);

  return dio;
}
