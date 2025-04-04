import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/src/core/utils/email.utils.dart';
import 'package:flutter_todo_app/src/features/tasks/models/task_model.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({this.task, super.key});

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shareWithController = TextEditingController();
  List<String> sharedWith = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      sharedWith = List.from(widget.task!.sharedWith);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _shareWithController.dispose();
    super.dispose();
  }

  void _shareTask(String taskId) {
    final shareUrl = 'Check out this task: $taskId';
    Share.share(shareUrl);
  }

  Future<void> _updateSharedWith(String email) async {
    final viewModel = context.read<TaskViewModel>();
    final user = FirebaseAuth.instance.currentUser!;
    if (!sharedWith.contains(email)) {
      sharedWith.add(email);
      final updatedTask = widget.task!.copyWith(
        sharedWith: sharedWith,
        updatedBy: user.uid,
      );
      await viewModel.updateTask(updatedTask, user.uid);
      setState(() {
        sharedWith = List.from(updatedTask.sharedWith);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TaskViewModel>();
    final user = FirebaseAuth.instance.currentUser!;
    final isEditMode = widget.task != null;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            AppBar(
              title: Text(
                isEditMode ? 'Edit Task' : 'New Task',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              actions:
                  isEditMode
                      ? [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () => _shareTask(widget.task!.id),
                          tooltip: 'Share Task',
                        ),
                      ]
                      : null,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Task Title',
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
                      if (isEditMode) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Share via Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _shareWithController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter recipient email',
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
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final recipientEmail =
                                    _shareWithController.text.trim();
                                await EmailUtils.sendTaskByEmail(
                                  context: context,
                                  recipientEmail: recipientEmail,
                                  subject:
                                      'Task: ${_titleController.text.trim()}',
                                  body: _descriptionController.text.trim(),
                                  taskId: widget.task!.id,
                                );
                                await _updateSharedWith(recipientEmail);
                                _shareWithController.clear();
                              },
                              icon: const Icon(Icons.email),
                              color: Colors.blue,
                              tooltip: 'Send Email',
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue[50],
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
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

                          if (isEditMode) {
                            final updatedTask = widget.task!.copyWith(
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              sharedWith: sharedWith,
                              updatedBy: user.uid,
                            );
                            await viewModel.updateTask(updatedTask, user.uid);
                          } else {
                            final newTask = TaskModel(
                              id:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              ownerId: user.uid,
                              sharedWith: [],
                              isCompleted: false,
                              createdAt: Timestamp.now(),
                              updatedBy: user.uid,
                            );
                            await viewModel.addTask(newTask);
                          }

                          if (mounted) {
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
                        child: Text(
                          isEditMode ? 'Update Task' : 'Create Task',
                          style: const TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}
