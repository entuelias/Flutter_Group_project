import '../repositories/medical_repository.dart';

class DeleteMedicalNoteUseCase {
  final MedicalRepository repository;

  DeleteMedicalNoteUseCase(this.repository);

  Future<void> call(String noteId) async {
    await repository.deleteMedicalNote(noteId);
  }
} 