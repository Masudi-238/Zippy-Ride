import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';
import '../../core/constants/api_constants.dart';
import '../auth/token_storage.dart';
import 'api_exceptions.dart';

/// HTTP client wrapper for the Zippy Ride backend API.
/// Handles authentication headers, error mapping, and token refresh.
class ApiClient {
  final http.Client _httpClient;
  final TokenStorage _tokenStorage;

  ApiClient({
    http.Client? httpClient,
    required TokenStorage tokenStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _tokenStorage = tokenStorage;

  String get _baseUrl => Environment.apiBaseUrl;

  /// Builds headers with optional auth token
  Future<Map<String, String>> _buildHeaders({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Performs a GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );
    return _handleRequest(() async {
      final headers = await _buildHeaders(auth: auth);
      return _httpClient.get(uri, headers: headers);
    });
  }

  /// Performs a POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return _handleRequest(() async {
      final headers = await _buildHeaders(auth: auth);
      return _httpClient.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Performs a PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return _handleRequest(() async {
      final headers = await _buildHeaders(auth: auth);
      return _httpClient.put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Performs a DELETE request
  Future<dynamic> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return _handleRequest(() async {
      final headers = await _buildHeaders(auth: auth);
      return _httpClient.delete(uri, headers: headers);
    });
  }

  /// Performs a multipart file upload
  Future<dynamic> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? fields,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    final headers = await _buildHeaders(auth: auth);
    request.headers.addAll(headers);

    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    if (fields != null) {
      request.fields.addAll(fields);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _processResponse(response);
  }

  /// Handles the request with error catching
  Future<dynamic> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(
        Duration(seconds: Environment.connectionTimeout),
      );
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on HttpException {
      throw const NetworkException(
        message: 'Could not reach the server.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'Invalid response from server.',
      );
    }
  }

  /// Processes the HTTP response and maps errors
  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 401:
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
      case 404:
        throw const NotFoundException();
      case 422:
        throw ValidationException(
          message: body?['message'] ?? 'Validation failed.',
          errors: body?['errors'] != null
              ? Map<String, List<String>>.from(
                  (body['errors'] as Map).map(
                    (key, value) => MapEntry(
                      key as String,
                      (value as List).cast<String>(),
                    ),
                  ),
                )
              : null,
        );
      case 500:
      default:
        throw ServerException(
          message: body?['message'] ?? 'An unexpected error occurred.',
        );
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _httpClient.close();
  }
}
