import 'package:flutter/material.dart';

class Message {
  final int id, company_id, user_id;
  final String body;
  final List<Mfile> mfiles;
  final DateTime created_at, updated_at;

  Message({
    required this.id,
    required this.user_id,
    required this.company_id,
    required this.body,
    this.mfiles = const [],
    required this.created_at,
    required this.updated_at,
  });
}

class Mfile {
  final int id, message_id;
  final String name, type, size;
  final DateTime created_at, updated_at;

  Mfile({
    required this.id,
    required this.message_id,
    required this.name,
    required this.type,
    required this.size,
    required this.created_at,
    required this.updated_at,
  });
}
