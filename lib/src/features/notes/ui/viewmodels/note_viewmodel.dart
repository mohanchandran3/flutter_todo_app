import 'package:flutter/cupertino.dart';
import 'package:flutter_todo_app/src/features/notes/models/note_model.dart';
import 'package:flutter_todo_app/src/features/notes/services/note_service.dart';

class NoteViewModel extends ChangeNotifier {

  final FirestoreService _firestoreService;
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  NoteViewModel({
    required FirestoreService firestoreService,
  })  : _firestoreService = firestoreService;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _hasCheckedCollection = false;

  void fetchTasks(String userId) async {
    _isLoading = true;
    _notes = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final stream = _firestoreService.getNotes(userId);
      stream.listen(
            (noteList) {
          if (_hasCheckedCollection && noteList.isEmpty) return;

          _notes = noteList;
          _isLoading = false;
          _hasCheckedCollection = true;

          if (_notes.isEmpty) {
            _errorMessage = null;
          } else {
            _errorMessage = null;
          }

          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage = 'Failed to fetch notes. Please try again.';
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch notes. Please try again.';
      notifyListeners();
    }
  }



  Future<void> addNote(NoteModel note) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firestoreService.createNote(note);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _errorMessage = "Failed to add note: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _firestoreService.updateNote(note);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firestoreService.deleteNote(noteId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}