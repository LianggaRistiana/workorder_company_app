import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppLoading()),
    );
  }
}
