import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_app/src/core/errors/exceptions.dart';
import 'package:flutter_todo_app/src/features/notes/models/note_model.dart';
import 'package:flutter_todo_app/src/features/tasks/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _noteCollection = 'notes';
  static const String _taskCollection = 'tasks';

  Future<void> createNote(NoteModel note) async {
    try {
      await _db.collection(_noteCollection).doc(note.id).set(note.toMap());
    } catch (e) {
      throw ServerException('Failed to create note: $e');
    }
  }

  Stream<List<NoteModel>> getNotes(String userId) {
    try {
      return _db
          .collection(_noteCollection)
          .where('ownerId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => NoteModel.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      throw ServerException('Failed to fetch notes: $e');
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _db.collection(_noteCollection).doc(note.id).update(note.toMap());
    } catch (e) {
      throw ServerException('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _db.collection(_noteCollection).doc(noteId).delete();
    } catch (e) {
      throw ServerException('Failed to delete note: $e');
    }
  }

  Future<void> createTask(TaskModel task) async {
    try {
      await _db.collection(_taskCollection).doc(task.id).set(task.toMap());
    } catch (e) {
      throw ServerException('Failed to create task: $e');
    }
  }

  Stream<List<TaskModel>> getTasks(String userId, String userEmail) {
    try {
      return _db
          .collection(_taskCollection)
          .where(
            Filter.or(
              Filter('ownerId', isEqualTo: userId),
              Filter('sharedWith', arrayContains: userEmail),
            ),
          )
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => TaskModel.fromFirestore(doc))
                    .toList(),
          );
    } catch (e) {
      throw ServerException('Failed to fetch tasks: $e');
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _db.collection(_taskCollection).doc(task.id).update(task.toMap());
    } catch (e) {
      throw ServerException('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection(_taskCollection).doc(taskId).delete();
    } catch (e) {
      throw ServerException('Failed to delete task: $e');
    }
  }
}
