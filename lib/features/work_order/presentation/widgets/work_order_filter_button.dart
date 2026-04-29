import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_bloc.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_selector.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class WorkOrderFilterButton extends StatelessWidget {
  const WorkOrderFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOrdersListBloc, WorkOrdersListState>(
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
                      "Filter Perintah Kerja",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              content: BlocProvider.value(
                value: context.read<WorkOrdersListBloc>(),
                child: BlocBuilder<WorkOrdersListBloc, WorkOrdersListState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.filter.serviceRequest != null) ...[
                            SectionTitle("Permintaan Layanan"),
                            ClickableCustomCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        IconBox.small(
                                            icon: AppIcon.serviceRequestInbox),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(state.filter
                                                    .serviceRequest?.code ??
                                                "Code tidak tersedia"))
                                      ],
                                    ),
                                    Text("Tekan untuk menghapus filter ini",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ))
                                  ],
                                ),
                                onTap: () =>
                                    context.read<WorkOrdersListBloc>().add(
                                          SetWorkOrderFilter(state.filter
                                              .copyWith(serviceRequest: null)),
                                        )),
                            const SizedBox(height: 8)
                          ],
                          SectionTitle("Pilih Status Perintah Kerja"),
                          WorkOrderStatusSelector(
                            values: WorkOrderStatus.values,
                            selectedValues: state.filter.status ?? [],
                            onChanged: (selected) {
                              context.read<WorkOrdersListBloc>().add(
                                    SetWorkOrderFilter(
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
