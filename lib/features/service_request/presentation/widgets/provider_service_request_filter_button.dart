import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_status_selector.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ProviderServiceRequestFilterButton extends StatelessWidget {
  const ProviderServiceRequestFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderServiceRequestsListBloc,
        ProviderServiceRequestsListState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final activeCount = state.filter.activeFilterCount;
        final isActive = activeCount > 0;

        return IconButton(
          onPressed: () {
            showAppBottomSheet(
              context,
              header: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    IconBox.small(icon: AppIcon.filter),
                    const SizedBox(width: 8),
                    Text(
                      "Filter Permintaan Layanan",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              content: BlocProvider.value(
                value: context.read<ProviderServiceRequestsListBloc>(),
                child: BlocBuilder<ProviderServiceRequestsListBloc,
                    ProviderServiceRequestsListState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle("Pilih Status Permintaan Layanan"),
                          ServiceRequestStatusSelector(
                            values: ServiceRequestStatus.values,
                            selectedValues: state.filter.status ?? [],
                            onChanged: (selected) {
                              context
                                  .read<ProviderServiceRequestsListBloc>()
                                  .add(
                                    SetServiceRequestFilter(
                                      state.filter.copyWith(
                                        status: List.of(selected),
                                      ),
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
          icon: Badge(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            isLabelVisible: activeCount > 0,
            label: Text(activeCount.toString()),
            child: Icon(
              AppIcon.filter,
              color: isActive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        );
      },
    );
  }
}
