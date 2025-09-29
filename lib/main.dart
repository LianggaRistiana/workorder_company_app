import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/theme/app_theme.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/route_generator.dart';
import 'package:workorder_company_app/core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        // Tambahkan bloc lain jika ada
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AppRoutes.login,
      ),
    );
  }
}