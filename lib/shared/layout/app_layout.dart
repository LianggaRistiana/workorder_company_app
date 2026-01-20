import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
// import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
// import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
// import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
// import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
// import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigantion_bar.dart';

// ===================== WIHT OUT ANIMATE ==============================
class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final path = GoRouterState.of(context).uri.path;
    // final isMainPage = false;

    if (authState is! Authenticated) {
      return const SizedBox.shrink();
    }

    final role = authState.user.role;
    final bool isMainPage = _roleMainPages[role]?.contains(path) ?? false;

    return Scaffold(
      body: child,
      bottomNavigationBar: isMainPage ? AppNavigationBar(role: role) : null,
    );
  }
}

final Map<UserRole, List<String>> _roleMainPages = {
  UserRole.ownerCompany: [AppRoutes.home],
  UserRole.managerCompany: [AppRoutes.home, AppRoutes.serviceRequest, AppRoutes.workorders],
  UserRole.staffCompany: [AppRoutes.home, AppRoutes.workorders],
  UserRole.staffUnassigned: [AppRoutes.home],
  UserRole.client: [AppRoutes.home, AppRoutes.publicCompanies],
};
// ===================== WIHT ANIMATE ==============================
// class AppLayout extends StatefulWidget {
//   final Widget child;

//   const AppLayout({super.key, required this.child});

//   @override
//   State<AppLayout> createState() => _AppLayoutState();
// }

// class _AppLayoutState extends State<AppLayout>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(0, 1), // Mulai dari bawah (hilang)
//       end: Offset.zero, // Berakhir di posisi asli (muncul)
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutQuart, // Curve yang lebih smooth
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = context.watch<AuthBloc>().state;
//     final path = GoRouterState.of(context).uri.path;

//     if (authState is! Authenticated) return const SizedBox.shrink();

//     final role = authState.user.role;
//     final bool isMainPage = _roleMainPages[role]?.contains(path) ?? false;

//     // Jalankan animasi
//     if (isMainPage) {
//       _controller.forward();
//     } else {
//       _controller.reverse();
//     }

//     return Scaffold(
//       body: widget.child,
//       // Perbaikan Utama: Jika isMainPage false, berikan null agar FAB naik ke Safe Area.
//       // Namun, kita bungkus dengan AnimatedBuilder agar Scaffold melakukan rebuild saat value animasi berubah.
//       bottomNavigationBar: isMainPage
//           ? SizeTransition(
//               sizeFactor: _controller,
//               axisAlignment: -1.0,
//               child: SlideTransition(
//                 position: _offsetAnimation,
//                 child: FadeTransition(
//                   opacity: _controller,
//                   child: AppNavigationBar(role: role),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }


// TODO : Thinks Later

 // List<BlocProvider> _providersByRole(UserRole role) {
  //   final providers = <BlocProvider>[];

  //   // Global (all roles)
  //   // providers.add(
  //   //   BlocProvider(create: (_) => sl<NotificationBloc>()),
  //   // );

  //   switch (role) {
  //     case UserRole.ownerCompany:
  //       providers.add(
  //         BlocProvider(create: (_) => sl<WorkorderBloc>()),
  //       );
  //       providers.add(
  //         BlocProvider(create: (_) => sl<EmployeesBloc>()),
  //       );
  //       providers.add(
  //         BlocProvider(create: (_) => sl<InternalCsrBloc>()),
  //       );
  //       // providers.add(
  //       //   BlocProvider(create: (_) => sl<FormsBloc>()),
  //       // );
  //       // providers.add(
  //       //   BlocProvider(create: (_) => sl<ServicesBloc>()),
  //       // );
  //       break;
  //     case UserRole.managerCompany:
  //       providers.add(
  //         BlocProvider(create: (_) => sl<WorkorderBloc>()),
  //       );
  //       providers.add(
  //         BlocProvider(create: (_) => sl<EmployeesBloc>()),
  //       );
  //       providers.add(
  //         BlocProvider(create: (_) => sl<InternalCsrBloc>()),
  //       );
  //       break;

  //     case UserRole.staffCompany:
  //       providers.add(
  //         BlocProvider(create: (_) => sl<WorkorderBloc>()),
  //       );
  //       break;

  //     case UserRole.client:
  //       providers.add(
  //         BlocProvider(create: (_) => sl<CsrBloc>()),
  //       );
  //       break;

  //     default:
  //       break;
  //   }

  //   return providers;
  // }