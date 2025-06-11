import '../models/medical_note.dart';
import '../repositories/medical_repository.dart';

class UpdateMedicalNoteUseCase {
  final MedicalRepository repository;

  UpdateMedicalNoteUseCase(this.repository);

  Future<MedicalNote> call(String noteId, MedicalNote note) async {
    return await repository.updateMedicalNote(noteId, note);
  }
} 