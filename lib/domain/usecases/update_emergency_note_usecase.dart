import '../models/emergency_note.dart';
import '../repositories/emergency_repository.dart';

class UpdateEmergencyNoteUseCase {
  final EmergencyRepository repository;
  UpdateEmergencyNoteUseCase(this.repository);

  Future<EmergencyNote> call(String noteId, EmergencyNote note) async {
    return await repository.updateEmergencyNote(noteId, note);
  }
} 