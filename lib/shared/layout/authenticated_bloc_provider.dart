import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticatedBlocProvider extends StatelessWidget {
  final Widget child;
  const AuthenticatedBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // TODO : add notification logs provider here
        // TODO : add notification active status provider heres
      ],
      child: child,
    );
  }
}
