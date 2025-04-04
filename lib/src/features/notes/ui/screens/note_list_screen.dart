import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/core/constants/app_constants.dart';
import 'package:flutter_todo_app/src/core/widgets/custom_bottom_navbar.dart';
import 'package:flutter_todo_app/src/features/notes/ui/screens/note_detail_screen.dart';
import 'package:flutter_todo_app/src/features/notes/ui/screens/note_form_screen.dart';
import 'package:flutter_todo_app/src/features/notes/ui/viewmodels/note_viewmodel.dart';
import 'package:flutter_todo_app/src/core/widgets/loading_indicator.dart';
import 'package:flutter_todo_app/src/features/notes/ui/widgets/note_card.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/screens/task_list_screen.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  NoteListScreenState createState() => NoteListScreenState();
}

class NoteListScreenState extends State<NoteListScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final viewModel = context.read<NoteViewModel>();
      viewModel.fetchTasks(user.uid);
    }
  }


  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TaskListScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteViewModel>();
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
                    'NOTE LIST',
                    style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red,),
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
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
          if (result == true) {
            final viewModel = context.read<NoteViewModel>();
            final user = FirebaseAuth.instance.currentUser!;
            viewModel.fetchTasks(user.uid);
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

  Widget _buildBody(BuildContext context, NoteViewModel viewModel, User user) {
    if (viewModel.isLoading && viewModel.notes.isEmpty) {
      return const LoadingIndicator();
    }

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.fetchTasks(user.uid);
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: viewModel.notes.length,
        itemBuilder: (context, index) {
          final note = viewModel.notes[index];
          return NoteCard(
            note: note,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
              );

              if (result == true) {
                final viewModel = context.read<NoteViewModel>();
                final user = FirebaseAuth.instance.currentUser!;
                viewModel.fetchTasks(user.uid);
              }
            },
          );
        },
      ),
    );
  }
}
