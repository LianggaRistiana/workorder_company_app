import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:workorder_company_app/core/services/messenger/app_messenger.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/services/fcm/fcm_listener.dart';
import 'package:workorder_company_app/core/theme/app_theme.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
// import 'package:workorder_company_app/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:workorder_company_app/routes/app_router.dart';
import 'package:workorder_company_app/core/di/injection.dart' as di;
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      debugPrint('FlutterError caught: ${details.exception}');
    };

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await di.init();
    await initializeDateFormatting('id_ID', null);

    final authRepo = di.sl<AuthRepository>();
    await authRepo.getCurrentUser(); // Populate the cache for the first time

    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint('Uncaught async error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FcmListener _listener = di.sl<FcmListener>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _listener.init());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              di.sl<AuthBloc>()..add(AuthCheckStatus()), // Auth state for UI
        ),
        BlocProvider<NotificationActiveCubit>(
            create: (_) => di.sl()), // TODO : remove this later
        BlocProvider<InternalGetCompanyCubit>(
            create: (_) =>
                di.sl()) // FIXME[Medium]: dont inject here, security issue
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: AppMessenger.messengerKey,
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
