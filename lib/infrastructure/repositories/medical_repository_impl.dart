import '../../domain/models/medical_note.dart';
import '../../domain/repositories/medical_repository.dart';
import '../datasources/medical_remote_datasource.dart';

class MedicalRepositoryImpl implements MedicalRepository {
  final MedicalRemoteDataSource remoteDataSource;

  MedicalRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MedicalNote>> getMedicalNotes(String userId) async {
    return await remoteDataSource.getMedicalNotes(userId);
  }

  @override
  Future<MedicalNote> createMedicalNote(MedicalNote note) async {
    return await remoteDataSource.createMedicalNote(note);
  }

  @override
  Future<MedicalNote> updateMedicalNote(String noteId, MedicalNote note) async {
    return await remoteDataSource.updateMedicalNote(noteId, note);
  }

  @override
  Future<void> deleteMedicalNote(String noteId) async {
    await remoteDataSource.deleteMedicalNote(noteId);
  }
} 