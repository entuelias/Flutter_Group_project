import 'package:dio/dio.dart';
import '../../domain/models/emergency_note.dart';
import '../../core/errors/auth_exception.dart';

class EmergencyRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  EmergencyRemoteDataSource(this._dio, this._baseUrl);

  String _getErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An unknown error occurred';
    } else if (e.response?.data is String) {
      return e.response?.data ?? 'An unknown string error occurred';
    }
    return 'Failed to connect to the server. Please check your network connection and server status.';
  }

  Future<List<EmergencyNote>> getEmergencyNotes(String userId) async {
    try {
      final response = await _dio.get('$_baseUrl/emergency-contacts');
      return (response.data as List)
          .map((json) => EmergencyNote.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<EmergencyNote> createEmergencyNote(EmergencyNote note) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/emergency-contacts',
        data: note.toJson(),
      );
      return EmergencyNote.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<EmergencyNote> updateEmergencyNote(String noteId, EmergencyNote note) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/emergency-contacts/$noteId',
        data: note.toJson(),
      );
      return EmergencyNote.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<void> deleteEmergencyNote(String noteId) async {
    try {
      await _dio.delete('$_baseUrl/emergency-contacts/$noteId');
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }
} 