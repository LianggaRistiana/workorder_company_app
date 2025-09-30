import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthBloc>().state;

    // if (authState is Unauthenticated) {
    //   Logger().i(authState);
    //   // return '/login';
    // }
    // if (authState is AuthInitial) {
    //   Logger().i(authState);
    //   // return '/login';
    // }
    // if (authState is Authenticated) {
    //   Logger().i(authState);
    // }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
