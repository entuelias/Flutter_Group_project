import '../../domain/models/emergency_note.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/emergency_remote_datasource.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDataSource remoteDataSource;
  EmergencyRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<EmergencyNote>> getEmergencyNotes(String userId) async {
    return await remoteDataSource.getEmergencyNotes(userId);
  }

  @override
  Future<EmergencyNote> createEmergencyNote(EmergencyNote note) async {
    return await remoteDataSource.createEmergencyNote(note);
  }

  @override
  Future<EmergencyNote> updateEmergencyNote(String noteId, EmergencyNote note) async {
    return await remoteDataSource.updateEmergencyNote(noteId, note);
  }

  @override
  Future<void> deleteEmergencyNote(String noteId) async {
    return await remoteDataSource.deleteEmergencyNote(noteId);
  }
} 