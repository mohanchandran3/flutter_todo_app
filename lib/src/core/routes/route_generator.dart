import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/features/auth/ui/screens/login_screen.dart';
import 'package:flutter_todo_app/src/features/auth/ui/screens/signup_screen.dart';
import 'package:flutter_todo_app/src/features/notes/ui/screens/note_list_screen.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/screens/task_list_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/notelist':
        return MaterialPageRoute(builder: (_) => const NoteListScreen());
      case '/tasklist':
        return MaterialPageRoute(builder: (_) => const TaskListScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}