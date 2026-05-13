import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:green_wheel/core/utils/local_storage.dart';
import 'package:green_wheel/core/utils/service_locator.dart';

/// A service class for handling API requests with Dio.
/// Supports GET, POST, PUT (update), PATCH and DELETE methods.
/// Uses a QueuedInterceptorsWrapper for silent 401 token refresh.
class ApiService {
  final String _baseUrl;
  final Dio _dio;
  String? _token;
  String? _language;
  final Logger _logger;

  ApiService(this._dio, {Logger? logger, String? baseUrl})
    : _baseUrl = baseUrl ?? '',
      _logger =
          logger ??
          Logger(
            printer: PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 50,
              colors: true,
              printEmojis: true,
            ),
          ) {
    _dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    );
  }

  /// Initializes the service by loading the latest token and language.
  Future<void> _initialize() async {
    _language = locator<LocalStorage>().language ?? 'ar';
  }

  /// Makes a GET request.
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('GET', uri, queryParameters: queryParameters);
    try {
      final response = await _dio.get(
        uri.toString(),
        queryParameters: queryParameters,
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    } catch (e) {
      _logger.e('Unexpected GET error', error: e);
      rethrow;
    }
  }

  /// Makes a POST request.
  Future<Map<String, dynamic>> post({
    required String endPoint,
    required dynamic data,
    bool isMultipart = false,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('POST', uri, data: data);
    try {
      final response = await _dio.post(
        uri.toString(),
        data: data,
        options: Options(
          headers: _buildHeaders(
            contentType: isMultipart
                ? 'multipart/form-data'
                : 'application/json',
          ),
        ),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a PUT request.
  Future<Map<String, dynamic>> update({
    required String endPoint,
    required dynamic data,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('PUT', uri, data: data);
    try {
      final response = await _dio.put(
        uri.toString(),
        data: data,
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a PATCH request.
  Future<Map<String, dynamic>> patch({
    required String endPoint,
    required dynamic data,
    bool isMultipart = false,
  }) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('PATCH', uri, data: data);
    try {
      final response = await _dio.patch(
        uri.toString(),
        data: data,
        options: Options(
          headers: _buildHeaders(
            contentType: isMultipart
                ? 'multipart/form-data'
                : 'application/json',
          ),
        ),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  /// Makes a DELETE request.
  Future<Map<String, dynamic>> delete({required String endPoint}) async {
    await _initialize();
    final uri = _buildUri(endPoint);
    _logRequest('DELETE', uri);
    try {
      final response = await _dio.delete(
        uri.toString(),
        options: Options(headers: _buildHeaders()),
      );
      _logResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _logError(e, uri);
      rethrow;
    }
  }

  // ========== PRIVATE HELPERS ========== //

  Uri _buildUri(String endPoint) {
    if (endPoint.startsWith('http')) return Uri.parse(endPoint);
    return Uri.parse(
      '$_baseUrl${endPoint.startsWith('/') ? endPoint.substring(1) : endPoint}',
    );
  }

  Map<String, dynamic> _buildHeaders({
    String contentType = 'application/json',
  }) {
    final headers = <String, dynamic>{
      'Content-Type': contentType,
      'Accept': 'application/json',
      'x-lang': _language ?? 'ar',
      'x-country': 'EG',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  void _logRequest(
    String method,
    Uri uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    _logger.d({
      'type': 'API Request',
      'method': method,
      'path': uri.path,
      'fullUrl': uri.toString(),
      if (queryParameters != null) 'queryParams': queryParameters,
      if (data != null) 'body': data,
    });
  }

  void _logResponse(Response response) {
    _logger.i({
      'type': 'API Response',
      'url': response.realUri.toString(),
      'data': response.data,
    });
  }

  void _logError(DioException error, Uri uri) {
    _logger.e({
      'type': 'API Error',
      'url': uri.toString(),
      'response': error.response?.data,
    });
  }
}
