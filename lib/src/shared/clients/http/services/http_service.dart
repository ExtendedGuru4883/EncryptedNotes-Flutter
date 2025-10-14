import 'package:dio/dio.dart';
import 'package:encrypted_notes/src/shared/exceptions/api_exception.dart';
import 'package:encrypted_notes/src/shared/exceptions/unauthorized_exception.dart';
import 'package:encrypted_notes/src/shared/utils/error_response_helper.dart';

class HttpService {
  final Dio dio;

  HttpService(this.dio);

  Future<T> getJson<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJsonT,
    String? authToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );

      final json = response.data!;
      return fromJsonT(json);
    } on DioException catch (ex) {
      throw (_handleDioException(ex));
    }
  }

  Future<T> postJson<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> json) fromJsonT,
    String? authToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );

      final json = response.data!;
      return fromJsonT(json);
    } on DioException catch (ex) {
      throw (_handleDioException(ex));
    }
  }

  Future<T> putJson<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> json) fromJsonT,
    String? authToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );

      final json = response.data!;
      return fromJsonT(json);
    } on DioException catch (ex) {
      throw (_handleDioException(ex));
    }
  }

  Future<void> postVoid({
    required String path,
    required Map<String, dynamic> data,
    String? authToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await dio.post<void>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );
    } on DioException catch (ex) {
      throw (_handleDioException(ex));
    }
  }

  Future<void> delete({
    required String path,
    String? authToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await dio.delete<void>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
      );
    } on DioException catch (ex) {
      throw (_handleDioException(ex));
    }
  }

  Exception _handleDioException(DioException ex) {
    if (ex.response != null) {
      final response = ex.response!;
      String? parsedErrorResponse;
      if (response.data is Map<String, dynamic>) {
        parsedErrorResponse = ErrorResponseHelper.parseErrorResponse(
          response.data as Map<String, dynamic>,
        );
      }
      return response.statusCode == 401
          ? UnauthorizedException(parsedErrorResponse ?? 'Unauthorized')
          : ApiException(parsedErrorResponse ?? 'Unexpected network error');
    }

    return ex;
  }
}
