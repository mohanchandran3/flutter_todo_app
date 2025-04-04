import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final List<String> sharedWith;
  final bool isCompleted;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final String? updatedBy;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.sharedWith,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
      updatedBy: data['updatedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': Timestamp.now(),
      'updatedBy': updatedBy,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    List<String>? sharedWith,
    bool? isCompleted,
    String? updatedBy,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
