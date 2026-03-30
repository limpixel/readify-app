import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor untuk logging dan error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException error) {
    String message = 'Terjadi kesalahan';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Koneksi timeout, silakan coba lagi';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Response timeout, silakan coba lagi';
        break;
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            message = 'Request tidak valid';
            break;
          case 401:
            message = 'Unauthorized, silakan login ulang';
            break;
          case 403:
            message = 'Akses ditolak';
            break;
          case 404:
            message = 'Data tidak ditemukan';
            break;
          case 500:
            message = 'Server error';
            break;
          default:
            message = 'Error: ${error.response?.statusCode}';
        }
        break;
      case DioExceptionType.connectionError:
        message = 'Gagal terhubung ke server';
        break;
      default:
        message = 'Terjadi kesalahan yang tidak diketahui';
    }
    
    print('API Error: $message');
  }
}
