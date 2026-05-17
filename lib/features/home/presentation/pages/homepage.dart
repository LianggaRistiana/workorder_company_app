import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/position_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/current_user_chip.dart';
import 'package:workorder_company_app/features/home/presentation/widget/client_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/manager_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/owner_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/staff_content.dart';
import 'package:workorder_company_app/features/home/presentation/widget/staff_unassigned_content.dart';
import 'package:workorder_company_app/features/notification/presentation/widgets/notification_button.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/position_user_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/orientation_helper.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // OrientationHelper.portraitOnly();
  }

  @override
  void dispose() {
    debugPrint('dispose Home');
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
      case UserRole.staffUnassigned:
        content = StaffUnassignedContent();
        break;
      case UserRole.client:
        content = ClientContent();
        break;
    }

    return Scaffold(
        // appBar bisa tetap
        appBar: context.isLandscape
            ? null
            : AppBar(
                title: CurrentUserChip(
                  onTap: () {
                    context.push(AppRoutes.profile);
                  },
                ),
                actions: [
                  NotificationButton(),
                ],
              ),
        body: AdaptiveWrapper(
            compact: _compactScreen(content),
            medium: _mediumScreen(content),
            expanded: _mediumScreen(content)));
  }

  Widget _compactScreen(Widget content) {
    return SizedBox.expand(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: SvgPicture.asset(
              "assets/images/hero-home-page.svg",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: double.infinity,
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
                child: Material(
                  color: Colors.transparent,
                  child: content,
                ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            left: 16,
            right: 16,
            child: PositionUserChip(),
          ).require(hasPosition()),
        ],
      ),
    );
  }

  Widget _mediumScreen(Widget content) {
    return SizedBox.expand(
        child: Stack(children: [
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SvgPicture.asset(
          "assets/images/hero-home-page.svg",
          fit: BoxFit.fill,
          alignment: Alignment.center,
        ),
      ),
      Positioned(
        top: 0,
        left: MediaQuery.of(context).size.width / 4,
        right: MediaQuery.of(context).size.width / 4,
        bottom: 0,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: content,
            ),
          ),
        ),
      )
    ]));
  }
}
