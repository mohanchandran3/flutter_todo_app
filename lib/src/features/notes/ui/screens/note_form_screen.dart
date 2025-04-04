import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/features/notes/models/note_model.dart';
import 'package:flutter_todo_app/src/features/auth/services/auth_service.dart';
import 'package:flutter_todo_app/src/features/notes/ui/viewmodels/note_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  NoteFormScreenState createState() => NoteFormScreenState();
}

class NoteFormScreenState extends State<NoteFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final User? currentUser = AuthService().currentUser;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
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
                'New Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (_titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Title cannot be empty'),
                            ),
                          );
                          return;
                        }

                        final task = NoteModel(
                          id: const Uuid().v4(),
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          ownerId: currentUser!.uid,
                          createdAt: Timestamp.now(),
                        );
                        await viewModel.addNote(task);
                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Create Note',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
