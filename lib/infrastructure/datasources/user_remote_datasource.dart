import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';

class UserRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  UserRemoteDataSource(this._dio, this._baseUrl) {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<User> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get user profile');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw Exception(e.response?.data['message']);
      }
      throw Exception('Network error occurred. Please try again.');
    }
  }

  Future<User> updateUserProfile(String token, User user) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update user profile');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw Exception(e.response?.data['message']);
      }
      throw Exception('Network error occurred. Please try again.');
    }
  }
} 