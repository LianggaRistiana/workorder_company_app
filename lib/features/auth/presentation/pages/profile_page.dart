import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_card_user.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_logout_button.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_menu_section.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is! Unauthenticated && current is Unauthenticated,
      listener: (context, state) {
        context.go(AppRoutes.login);
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(child: AppLoading()),
            );
          }

          if (state is Authenticated) {
            return Scaffold(
              appBar: AppBar(
                // title: const Text("Profile"),
                // centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileUserCard(user: state.user),
                    const SizedBox(height: 16),
                    const Divider(),
                    const ProfileMenuSection(),
                    const SizedBox(height: 8),
                    const ProfileLogoutButton(),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
