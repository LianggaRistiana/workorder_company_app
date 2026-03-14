import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/auth/domain/entities/base_user_entity.dart';

class UserSummaryView extends StatelessWidget {
  final BaseUserEntity user;

  const UserSummaryView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        user.name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      Text(user.email, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
