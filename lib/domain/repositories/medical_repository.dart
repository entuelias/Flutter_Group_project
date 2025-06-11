import '../models/medical_note.dart';

abstract class MedicalRepository {
  Future<List<MedicalNote>> getMedicalNotes(String userId);
  Future<MedicalNote> createMedicalNote(MedicalNote note);
  Future<MedicalNote> updateMedicalNote(String noteId, MedicalNote note);
  Future<void> deleteMedicalNote(String noteId);
} 