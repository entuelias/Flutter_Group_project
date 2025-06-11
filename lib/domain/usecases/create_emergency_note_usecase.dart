import '../models/emergency_note.dart';
import '../repositories/emergency_repository.dart';

class CreateEmergencyNoteUseCase {
  final EmergencyRepository repository;
  CreateEmergencyNoteUseCase(this.repository);

  Future<EmergencyNote> call(EmergencyNote note) async {
    return await repository.createEmergencyNote(note);
  }
} 