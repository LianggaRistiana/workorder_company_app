import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_theme.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  // Initial Depedencies Injection
  // await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: "Work Order Company App",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AppRoutes.login,
      );
  }
}