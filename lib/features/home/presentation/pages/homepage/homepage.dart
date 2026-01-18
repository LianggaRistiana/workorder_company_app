import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/current_user_chip.dart';
import 'package:workorder_company_app/features/home/presentation/widget/client_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/manager_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/owner_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/staff_content.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/orientation_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    OrientationHelper.portraitOnly();
  }

  @override
  void dispose() {
    OrientationHelper.all();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const SizedBox.shrink();
    }

    final role = authState.user.role;

    Widget content;
    switch (role) {
      case UserRole.ownerCompany:
        content = OwnerContent();
        break;
      case UserRole.managerCompany:
        content = ManagerContent();
        break;
      case UserRole.staffCompany:
        content = StaffContent();
        break;
      case UserRole.client:
      default:
        content = ClientContent();
        break;
    }

    return Scaffold(
        // appBar bisa tetap
        appBar: AppBar(
          title: CurrentUserChip(
            onTap: () {
              context.push(AppRoutes.profile);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notifications_outlined))
          ],
        ),

        // ===== Menggunakan Stack untuk background + card =====
        body: SizedBox.expand(
          child: Stack(
            children: [
              // ==========================
              // BACKGROUND IMAGE
              // ==========================
              SizedBox(
                width: double.infinity,
                height: 220,
                child: Image.asset(
                  "assets/images/header-home.png",
                  fit: BoxFit.cover,
                ),
              ),

              // ==========================
              // WHITE FLOATING CARD
              // ==========================
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: double.infinity, // WAJIB untuk memenuhi area
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),

                  child: SingleChildScrollView(
                    child: content,
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [],
                    // ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
