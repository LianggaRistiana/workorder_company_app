import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_state.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

// FIXME[API REQUIRED] : currently, staff forbidden to access this. allowed expected
class InternalCompanyCard extends StatelessWidget {
  const InternalCompanyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalGetCompanyCubit, InternalGetCompanyState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final company = state.company;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state.isLoading && company == null
              ? SmartShimmer(
                  key: const ValueKey('loading'),
                  placeholders: [
                    ShimmerPlaceholder(
                        height: 90, width: double.infinity, borderRadius: 24),
                  ],
                )
              : company == null
                  ? const SizedBox.shrink(key: ValueKey('empty'))
                  : Container(
                      key: const ValueKey('company'),
                      width: double.infinity,
                      height: 90,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFADC6FF), Color(0xFFDEBCDF)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(AppIcon.company, size: 30, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  company.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (company.address.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    company.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
