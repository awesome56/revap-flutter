import 'package:flutter/material.dart';

class Branch {
  final int id, company_id;
  final String name,
      email,
      phone,
      website,
      img,
      manager,
      location,
      code,
      qrcode;
  final DateTime created_at, updated_at;

  Branch({
    required this.id,
    required this.company_id,
    required this.name,
    this.email = "",
    this.phone = "",
    this.website = "",
    this.img = "",
    this.manager = "",
    required this.location,
    required this.code,
    required this.qrcode,
    required this.created_at,
    required this.updated_at,
  });
}
