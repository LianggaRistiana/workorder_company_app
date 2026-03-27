import 'package:flutter/material.dart';

class ServiceConfigControllers {
  final TextEditingController title;
  final TextEditingController description;

  ServiceConfigControllers({
    required this.title,
    required this.description,
  });

  void dispose() {
    title.dispose();
    description.dispose();
  }
}
