import 'package:dio/dio.dart';
import '../../domain/models/medical_note.dart';
import '../../core/errors/auth_exception.dart';

class MedicalRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  MedicalRemoteDataSource(this._dio, this._baseUrl);

  String _getErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An unknown error occurred';
    } else if (e.response?.data is String) {
      return e.response?.data ?? 'An unknown string error occurred';
    }
    return 'Failed to connect to the server. Please check your network connection and server status.';
  }

  Future<List<MedicalNote>> getMedicalNotes(String userId) async {
    try {
      final response = await _dio.get('$_baseUrl/medical-info');
      return (response.data as List)
          .map((json) => MedicalNote.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<MedicalNote> createMedicalNote(MedicalNote note) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/medical-info',
        data: note.toJson(),
      );
      return MedicalNote.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<MedicalNote> updateMedicalNote(String noteId, MedicalNote note) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/medical-info/$noteId',
        data: note.toJson(),
      );
      return MedicalNote.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }

  Future<void> deleteMedicalNote(String noteId) async {
    try {
      await _dio.delete('$_baseUrl/medical-info/$noteId');
    } on DioException catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }
} 