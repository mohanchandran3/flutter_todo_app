import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/features/notes/models/note_model.dart';
import 'package:flutter_todo_app/src/features/notes/ui/viewmodels/note_viewmodel.dart';
import 'package:provider/provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({required this.note, super.key});

  @override
  NoteDetailScreenState createState() => NoteDetailScreenState();
}

class NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(
      text: widget.note.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NoteViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Note Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100],
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title Field
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Note Title',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description Field
                        TextField(
                          controller: _descriptionController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w100,),
                        ),
                        const SizedBox(height: 32),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              context: context,
                              icon: Icons.save,
                              color: Colors.blue,
                              onPressed: () async {
                                if (_titleController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Title cannot be empty'),
                                    ),
                                  );
                                  return;
                                }
                                final updatedNote = widget.note.copyWith(
                                  title: _titleController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                );
                                await viewModel.updateNote(updatedNote);
                                if (mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                              tooltip: 'Update Note',
                            ),
                            _buildActionButton(
                              context: context,
                              icon: Icons.delete,
                              color: Colors.red,
                              onPressed: () async {
                                await viewModel.deleteNote(widget.note.id);
                                if (mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                              tooltip: 'Delete Note',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: 4,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
