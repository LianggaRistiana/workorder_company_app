import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralListener extends StatelessWidget {
  final Widget child;
  const GeneralListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // TODO : add notification logs listener here
        // TODO : add notification active status listener here
      ],
      child: child,
    );
  }
}
