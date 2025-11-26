import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';

class CurrentUserChip extends StatelessWidget {
  final VoidCallback? onTap;

  const CurrentUserChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;

    if (state is Authenticated) {
      return UserChip(
        user: state.user,
        onTap: onTap,
      );
    }

    return const SizedBox.shrink();
  }
}
