import '../models/emergency_note.dart';

abstract class EmergencyRepository {
  Future<List<EmergencyNote>> getEmergencyNotes(String userId);
  Future<EmergencyNote> createEmergencyNote(EmergencyNote note);
  Future<EmergencyNote> updateEmergencyNote(String noteId, EmergencyNote note);
  Future<void> deleteEmergencyNote(String noteId);
} 