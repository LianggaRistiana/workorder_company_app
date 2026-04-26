import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_card_user.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_logout_button.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/profile_menu_section.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/user_property_display.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authBloc = context.read<AuthBloc>();

      final state = authBloc.state;
      if (state is Authenticated) {
        final user = state.user;

        if (user.role.canPermission(CompanyPermission.view)) {
          context.read<InternalGetCompanyCubit>().loadCompany();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
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
                child: AdaptiveSplitColumn(
                    leftChildren: _profileData(state.user),
                    rightChildren: _menuSettings())),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _profileData(UserEntity user) {
    return [
      Column(
        children: [
          InternalCompanyCard(),
          const SizedBox(height: AppSpacing.md),
        ],
      ).require(roleCan(CompanyPermission.view)),
      ProfileUserCard(user: user),
      UserPropertyDisplay(user: user),
    ];
  }

  List<Widget> _menuSettings() {
    return [
      const ProfileMenuSection(),
      const SizedBox(height: AppSpacing.md),
      const ProfileLogoutButton(),
      const SizedBox(height: AppSpacing.lg),
    ];
  }
}
