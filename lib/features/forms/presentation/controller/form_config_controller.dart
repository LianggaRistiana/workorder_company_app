import 'package:flutter/material.dart';

class FormConfigController {
  final TextEditingController title;
  final TextEditingController description;

  FormConfigController({
    required this.title,
    required this.description,
  });

  void dispose() {
    title.dispose();
    description.dispose();
  }
}
