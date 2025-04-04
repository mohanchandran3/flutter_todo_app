import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/core/constants/app_constants.dart';
import 'package:flutter_todo_app/src/core/widgets/custom_bottom_navbar.dart';
import 'package:flutter_todo_app/src/features/notes/ui/screens/note_list_screen.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/screens/task_form_screen.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/viewmodels/task_view_model.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TaskViewModel>();
    final user = FirebaseAuth.instance.currentUser!;
    viewModel.fetchTasks(user.uid, user.email!);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NoteListScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _buildBody(context, viewModel, user),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
          if (result == true) {
            viewModel.fetchTasks(user.uid, user.email!);
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody(BuildContext context, TaskViewModel viewModel, User user) {
    if (viewModel.isLoading && viewModel.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final activeTasks =
        viewModel.tasks.where((task) => !task.isCompleted).toList();
    final completedTasks =
        viewModel.tasks.where((task) => task.isCompleted).toList();

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.fetchTasks(user.uid, user.email!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            if (activeTasks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'Active Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              ...activeTasks.map(
                (task) => TaskCard(
                  task: task,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskFormScreen(task: task),
                      ),
                    );
                    if (result == true) {
                      viewModel.fetchTasks(user.uid, user.email!);
                    }
                  },
                  onComplete: (value) async {
                    final updatedTask = task.copyWith(isCompleted: value);
                    await viewModel.updateTask(updatedTask, user.uid);
                  },
                ),
              ),
            ],
            if (completedTasks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Text(
                  'Completed Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              ...completedTasks.map(
                (task) => TaskCard(
                  task: task,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskFormScreen(task: task),
                      ),
                    );
                    if (result == true) {
                      viewModel.fetchTasks(user.uid, user.email!);
                    }
                  },
                  onComplete: (value) async {
                    final updatedTask = task.copyWith(isCompleted: value);
                    await viewModel.updateTask(updatedTask, user.uid);
                  },
                ),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
