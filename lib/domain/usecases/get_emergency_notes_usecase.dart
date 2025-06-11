import '../models/emergency_note.dart';
import '../repositories/emergency_repository.dart';

class GetEmergencyNotesUseCase {
  final EmergencyRepository repository;
  GetEmergencyNotesUseCase(this.repository);

  Future<List<EmergencyNote>> call(String userId) async {
    return await repository.getEmergencyNotes(userId);
  }
} 