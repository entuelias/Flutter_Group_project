import '../repositories/emergency_repository.dart';

class DeleteEmergencyNoteUseCase {
  final EmergencyRepository repository;
  DeleteEmergencyNoteUseCase(this.repository);
 
  Future<void> call(String noteId) async {
    return await repository.deleteEmergencyNote(noteId);
  }
} 