import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_state.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ServiceFilterButton extends StatelessWidget {
  const ServiceFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesListBloc, ServicesListState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final activeCount = state.filter.activeFilter;
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
                      "Filter Layanan",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              content: BlocProvider.value(
                value: context.read<ServicesListBloc>(),
                child: BlocBuilder<ServicesListBloc, ServicesListState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Access type — multi select
                          EnumSelector<ServiceAccessType>(
                            title: "Tipe Akses",
                            values: ServiceAccessType.values,
                            selectedValues: state.filter.types ?? [],
                            labelBuilder: (type) => type.displayName,
                            onChanged: (selected) {
                              context.read<ServicesListBloc>().add(
                                    SetServiceFilterRequested(
                                      state.filter.copyWith(
                                        types: List.of(selected),
                                      ),
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Active status filter
                          SectionTitle("Status Aktif"),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilterChip(
                                label: const Text("Aktif"),
                                selected: state.filter.isActive == true,
                                onSelected: (selected) {
                                  context.read<ServicesListBloc>().add(
                                        SetServiceFilterRequested(
                                          state.filter.copyWith(
                                            isActive: selected ? true : null,
                                          ),
                                        ),
                                      );
                                },
                              ),
                              FilterChip(
                                label: const Text("Tidak Aktif"),
                                selected: state.filter.isActive == false,
                                onSelected: (selected) {
                                  context.read<ServicesListBloc>().add(
                                        SetServiceFilterRequested(
                                          state.filter.copyWith(
                                            isActive: selected ? false : null,
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ],
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
