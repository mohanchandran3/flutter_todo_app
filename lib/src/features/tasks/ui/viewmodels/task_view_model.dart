import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/features/notes/services/note_service.dart';
import 'package:flutter_todo_app/src/features/tasks/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  TaskViewModel({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _hasCheckedCollection = false;

  void fetchTasks(String userId, String userEmail) async {
    _isLoading = true;
    _tasks = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final stream = _firestoreService.getTasks(userId, userEmail);
      stream.listen(
        (taskList) {
          if (_hasCheckedCollection && taskList.isEmpty) return;

          _tasks = taskList;
          _isLoading = false;
          _hasCheckedCollection = true;

          if (_tasks.isEmpty) {
            _errorMessage = null;
          } else {
            _errorMessage = null;
          }

          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage = 'Failed to fetch tasks. Please try again.';
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch tasks. Please try again.';
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firestoreService.createTask(task);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Failed to add task: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task, String currentUserId) async {
    try {
      final updatedTask = task.copyWith(updatedBy: currentUserId);
      await _firestoreService.updateTask(updatedTask);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to update task: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestoreService.deleteTask(taskId);
    } catch (e) {
      _errorMessage = "Failed to delete task: ${e.toString()}";
      notifyListeners();
    }
  }
}
