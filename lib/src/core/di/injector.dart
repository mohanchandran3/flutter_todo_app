import 'package:flutter_todo_app/src/features/notes/services/note_service.dart';
import 'package:flutter_todo_app/src/features/notes/ui/viewmodels/note_viewmodel.dart';
import 'package:flutter_todo_app/src/features/tasks/ui/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static final allProviders = <SingleChildWidget>[
    Provider(create: (_) => FirestoreService()),
    ChangeNotifierProvider(
      create: (context) => NoteViewModel(
        firestoreService: context.read<FirestoreService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => TaskViewModel(
        firestoreService: context.read<FirestoreService>(),
      ),
    ),
  ];
}