import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../core/params/login_params.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../core/errors/auth_exception.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;
  final Ref _ref;

  AuthRemoteDataSource(this._dio, this._baseUrl, this._ref) {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();

  SharedPreferences get _sharedPreferences => _ref.read(sharedPreferencesProvider);

  String _getErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An unknown error occurred';
    } else if (e.response?.data is String) {
      return e.response?.data ?? 'An unknown string error occurred';
    }
    return 'Failed to connect to the server. Please check your network connection and server status.';
  }

  Future<Map<String, dynamic>> signUp(User user, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/signup',
        data: {
          ...user.toJson(),
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw AuthException(response.data['message'] ?? 'Sign up failed');
      }
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<User> login(LoginParams params) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'email': params.email,
          'password': params.password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data;

        if (token != null) {
          await _secureStorage.write(key: 'jwt_token', value: token);
        }
        if (userData != null && userData['_id'] != null) {
          await _sharedPreferences.setString('user_id', userData['_id']);
        }
        if (userData != null && userData['username'] != null) {
          await _sharedPreferences.setString('username', userData['username']);
        }
        
        return User.fromJson(userData);
      } else {
        throw AuthException(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<User?> getUserDetails(String userId) async {
    try {
      final response = await _dio.get('$_baseUrl/users/$userId'); // Assuming endpoint /users/:userId
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // User not found
      }
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    await _sharedPreferences.remove('user_id');
    await _sharedPreferences.remove('username');
  }
} 