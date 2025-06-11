import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/medical_note.dart';
import '../../providers/medical_provider.dart';
import '../../providers/auth_provider.dart';

class MedicalInfoScreen extends ConsumerStatefulWidget {
  const MedicalInfoScreen({super.key});

  @override
  ConsumerState<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends ConsumerState<MedicalInfoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _showAddForm = false;
  MedicalNote? _editingNote;

  @override
  void initState() {
    super.initState();
    // Load medical notes when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userProvider)?.id; // Get user ID from provider
      if (userId != null) {
        ref.read(medicalNotesProvider.notifier).loadMedicalNotes(userId);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final userId = ref.read(userProvider)?.id; // Get user ID from provider
    if (userId == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add medical info.')),
      );
      return;
    }

    if (_titleController.text.isEmpty) return;

    final note = MedicalNote(
      id: _editingNote?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID for new notes
      userId: userId,
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: _editingNote?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_editingNote != null) {
      ref.read(medicalNotesProvider.notifier).updateMedicalNote(_editingNote!.id, note);
    } else {
      ref.read(medicalNotesProvider.notifier).createMedicalNote(note);
    }

    _resetForm();
  }

  void _handleEdit(MedicalNote note) {
    setState(() {
      _editingNote = note;
      _titleController.text = note.title;
      _descriptionController.text = note.description;
      _showAddForm = true;
    });
  }

  void _handleDelete(String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(medicalNotesProvider.notifier).deleteMedicalNote(noteId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _showAddForm = false;
      _editingNote = null;
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicalNotes = ref.watch(medicalNotesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Medical Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _resetForm();
                    setState(() {
                      _showAddForm = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: medicalNotes.when(
                  data: (notes) {
                    if (notes.isEmpty) {
                      return const Center(child: Text('No medical notes found. Add a new one!'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildInfoCard(
                            title: note.title,
                            description: note.description,
                            onEdit: () => _handleEdit(note),
                            onDelete: () => _handleDelete(note.id),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error: ${error.toString()}'),
                  ),
                ),
              ),
            ],
          ),
          if (_showAddForm)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editingNote != null ? 'Edit Info' : 'Add Info',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description/Note',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _resetForm,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _handleSave,
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
