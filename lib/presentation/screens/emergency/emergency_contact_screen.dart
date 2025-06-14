import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/emergency_note.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/auth_provider.dart';

class EmergencyContactScreen extends ConsumerStatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  ConsumerState<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends ConsumerState<EmergencyContactScreen> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _showAddForm = false;
  EmergencyNote? _editingNote;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userProvider)?.id;
      if (userId != null) {
        ref.read(emergencyNotesProvider.notifier).loadEmergencyNotes(userId);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final userId = ref.read(userProvider)?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add emergency contact.')),
      );
      return;
    }
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;
    // Phone number validation
    final phone = _phoneController.text.trim();
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }
    final note = EmergencyNote(
      id: _editingNote?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: _nameController.text,
      relation: _relationController.text,
      phoneNumber: phone,
      createdAt: _editingNote?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (_editingNote != null) {
      ref.read(emergencyNotesProvider.notifier).updateEmergencyNote(_editingNote!.id, note);
    } else {
      ref.read(emergencyNotesProvider.notifier).createEmergencyNote(note);
    }
    _resetForm();
  }

  void _handleEdit(EmergencyNote note) {
    setState(() {
      _editingNote = note;
      _nameController.text = note.name;
      _relationController.text = note.relation;
      _phoneController.text = note.phoneNumber;
      _showAddForm = true;
    });
  }

  void _handleDelete(String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(emergencyNotesProvider.notifier).deleteEmergencyNote(noteId);
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
      _nameController.clear();
      _relationController.clear();
      _phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final emergencyNotes = ref.watch(emergencyNotesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Emergency Contact'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Store and manage trusted emergency numbers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: emergencyNotes.when(
                  data: (notes) {
                    if (notes.isEmpty) {
                      return const Center(child: Text('No emergency contacts found. Add a new one!'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildContactCard(
                            name: note.name,
                            relation: note.relation,
                            phoneNumber: note.phoneNumber,
                            onEdit: () => _handleEdit(note),
                            onDelete: () => _handleDelete(note.id),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error:  {error.toString()}'),
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
                        _editingNote != null ? 'Edit Contact' : 'Add Contact',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _relationController,
                        decoration: const InputDecoration(
                          hintText: 'Relation',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetForm();
          setState(() {
            _showAddForm = true;
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String relation,
    required String phoneNumber,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Relation: $relation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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
        ],
      ),
    );
  }
}