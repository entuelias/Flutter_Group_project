import '../models/medical_note.dart';
import '../repositories/medical_repository.dart';

class CreateMedicalNoteUseCase {
  final MedicalRepository repository;

  CreateMedicalNoteUseCase(this.repository);

  Future<MedicalNote> call(MedicalNote note) async {
    return await repository.createMedicalNote(note);
  }
} 