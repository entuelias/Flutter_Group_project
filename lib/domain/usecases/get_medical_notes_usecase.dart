import '../models/medical_note.dart';
import '../repositories/medical_repository.dart';

class GetMedicalNotesUseCase {
  final MedicalRepository repository;

  GetMedicalNotesUseCase(this.repository);

  Future<List<MedicalNote>> call(String userId) async {
    return await repository.getMedicalNotes(userId);
  }
} 