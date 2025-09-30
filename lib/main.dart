import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/theme/app_theme.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_router.dart';
// import 'package:workorder_company_app/routes/app_routes.dart';
// import 'package:workorder_company_app/routes/route_generator.dart';
import 'package:workorder_company_app/core/di/injection.dart' as di;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await di.init();

//   runApp(const MyApp());
// }

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Tangkap semua error synchronous dari Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      debugPrint('FlutterError caught: ${details.exception}');
    };

    // Inisialisasi dependency injection
    await di.init();

    // Kurang bestpractice tapi cara tercepat
    final authRepo = di.sl<AuthRepository>();
    await authRepo.getCurrentUser();

    // Jalankan aplikasi
    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint('Uncaught async error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}




// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (_) => di.sl<AuthBloc>()..add(AuthCheckStatus()),
//         ),
//         // Tambahkan bloc lain jika ada
//       ],
//       child: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           // Handle navigasi sesuai state
//           if (state is Authenticated) {
//             context.go('/home');
//           } else if (state is Unauthenticated) {
//             context.go('/login');
//           }
//         },
//         child: MaterialApp.router(
//           title: AppConfig.appName,
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.lightTheme,
//           darkTheme: AppTheme.darkTheme,
//           routerConfig: appRouter,
//         ),
//       ),
//     );
//   }
// }

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
      child: MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: appRouter
          ),
    );
  }
}
