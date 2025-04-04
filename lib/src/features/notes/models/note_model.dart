import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'updatedAt': Timestamp.now(),
    };
  }

  NoteModel copyWith({
    String? title,
    String? description,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }
}