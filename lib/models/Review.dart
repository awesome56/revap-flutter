import 'package:flutter/material.dart';

class Review {
  final int id, branch_id, user_id, rating;
  final String title, body, location;
  final List<File> files;
  final DateTime created_at, updated_at;

  Review({
    required this.id,
    required this.user_id,
    required this.branch_id,
    required this.title,
    this.body = "",
    this.rating = 0,
    required this.location,
    required this.created_at,
    required this.updated_at,
    this.files = const [],
  });
}

class File {
  final int id, review_id;
  final String name, type, size;
  final DateTime created_at, updated_at;

  File({
    required this.id,
    required this.review_id,
    required this.name,
    required this.type,
    required this.size,
    required this.created_at,
    required this.updated_at,
  });
}
