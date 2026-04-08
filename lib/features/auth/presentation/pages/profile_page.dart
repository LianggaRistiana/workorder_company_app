import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_card_user.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_logout_button.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_menu_section.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/user_property_display.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    final authBloc = context.read<AuthBloc>();

    if (authBloc.state is Authenticated) {
      final user = (authBloc.state as Authenticated).user;
      if (user.role.canPermission(CompanyPermission.view)) {
        context.read<InternalGetCompanyCubit>().loadCompany();
      }
    }
  }

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
              appBar: AppBar(),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          InternalCompanyCard(),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ).require(roleCan(CompanyPermission.view)),
                      ProfileUserCard(user: state.user),
                      UserPropertyDisplay(user: state.user),
                      const Divider(),
                      const ProfileMenuSection(),
                      const SizedBox(height: AppSpacing.md),
                      const ProfileLogoutButton(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
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
