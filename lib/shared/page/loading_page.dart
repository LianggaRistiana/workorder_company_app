import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppLoading()),
    );
  }
}
